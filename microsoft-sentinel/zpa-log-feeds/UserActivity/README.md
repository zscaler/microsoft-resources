# Zscaler ZPA UserActivity → Microsoft Sentinel (Cloud NSS) — Setup Guide

This stands up a DCR-based ingest pipeline that lands ZPA UserActivity logs in your Sentinel workspace's `ZPA_CL` table via Zscaler's Cloud NSS feed.

**Repo files used (this directory):**
- `cloud-nss-zpa-useractivity.bicep` — DCE + DCR + `ZPA_CL` table
- `cloud-nss-zpa-useractivity.fof` — Zscaler-side payload template
- `ZPAUserActivity.kql` — shared parsing function (works for Cloud NSS + VM/syslog paths)
- `ZPAUserActivity.workbook` — Sentinel workbook

---

## Prerequisites

- An Azure subscription with a Log Analytics workspace (Sentinel optional)
- Azure CLI ≥ 2.50 with the bicep extension (`az bicep version`)
- Zscaler tenant with ZPA + Cloud NSS enabled
- Permissions to:
  - Deploy resources to the target subscription
  - Create an App Registration in Entra ID
  - Assign roles on a DCR scope
  - Configure the Zscaler admin portal

You'll need these values from your workspace (Azure Portal → Log Analytics → Overview):
- Subscription ID
- Resource group name
- Workspace name
- Workspace ID (the GUID under "Workspace ID", **not** the resource ID)
- Workspace location (e.g. `australiaeast`)

---

## Step 1 — Create the App Registration Zscaler will authenticate as

```bash
az ad sp create-for-rbac --name sp-zscaler-zpa-cloudnss
```

Capture the output — `appId`, `password`, `tenant`. Treat the password as a secret.

---

## Step 2 — Deploy the bicep

```bash
cd microsoft-resources/microsoft-sentinel/zpa-log-feeds/UserActivity

az stack group create \
  --name cloud-nss-zpa-useractivity \
  --resource-group <your-rg> \
  --template-file ./cloud-nss-zpa-useractivity.bicep \
  --parameters \
    resourceGroup=<your-rg> \
    workspaceName=<your-workspace-name> \
    location=<workspace-location> \
    subscriptionId=<your-subscription-id> \
    workspaceId=<workspace-customer-id-guid> \
    dceName=dce-zpa-useractivity-cloudnss \
    dcrName=dcr-zpa-useractivity-cloudnss \
  --deny-settings-mode none \
  --action-on-unmanage deleteResources \
  --yes
```

Optional: append `retentionInDays=<n>` to override the 90-day default. On any **redeploy**, pass your current retention value to preserve it (this param is applied on every deploy).

Save the `api_url` output — that's the ingest URL Zscaler needs.

```bash
az stack group show -g <your-rg> -n cloud-nss-zpa-useractivity --query outputs.api_url -o tsv
```

---

## Step 3 — Grant the App Registration `Monitoring Metrics Publisher` on the DCR

```bash
SP_OBJECT_ID=$(az ad sp show --id <appId-from-step-1> --query id -o tsv)
DCR_ID=$(az stack group show -g <your-rg> -n cloud-nss-zpa-useractivity --query outputs.dcr_resource_id.value -o tsv)

az role assignment create \
  --assignee-object-id "$SP_OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --role 'Monitoring Metrics Publisher' \
  --scope "$DCR_ID"
```

Wait ~1 minute for role propagation before testing.

---

## Step 4 — Configure the Zscaler portal Cloud NSS feed

In the Zscaler admin portal → **Administration → Cloud NSS → NSS Feeds → Add NSS Feed**, set the fields as follows.

### SIEM Connectivity

| Field | Value |
|---|---|
| **SIEM Type** | `Azure Sentinel` |
| **OAuth 2.0 Authentication** | toggle **ON** |
| **Client Id** | `<appId>` from Step 1 |
| **Client Secret** | `<password>` from Step 1 |
| **Scope** | `https://monitor.azure.com//.default` (note: **double slash** before `.default` — Azure resource URI quirk, not a typo) |
| **Grant Type** | `client_credentials` |
| **Authorization URL** | `https://login.microsoftonline.com/<tenant>/oauth2/v2.0/token` |
| **Max Batch Size** | `512` `KB` |
| **API URL** | the `api_url` output from Step 2 |

### HTTP Headers

| Key | Value |
|---|---|
| `Content-Type` | `application/json` |

(Click **Add HTTP Header** to add this row — it's required; the DCR ingest endpoint rejects payloads without it.)

### Formatting

| Field | Value |
|---|---|
| **Log Type** | `User Activity` |
| **Feed Output Type** | `JSON` |
| **JSON Array Notation** | enabled (toggle **ON**) |
| **Feed Escape Character** | `,\` |
| **Feed Output Format** | paste the contents of `cloud-nss-zpa-useractivity.fof` (single-line wrapped JSON: `{"sourcetype":"...","event":{...}}`) |

Save and **enable** the feed.

---

## Step 5 — Install the parsing function in your Sentinel workspace

The `ZPA_CL` table receives the inner event JSON in its `Message` column. The `ZPAUserActivity()` function parses it into typed columns, handling timestamps from both Cloud NSS (epoch numbers) and the legacy VM/syslog path (strftime/ISO strings).

In the Azure Portal → Log Analytics → Logs:
1. Open the contents of `ZPAUserActivity.kql`.
2. Paste into the query window, click **Save → Save as function**.
3. **Function name:** `ZPAUserActivity`
4. **Category:** `Zscaler` (or whatever you prefer).
5. Save.

---

## Step 6 — Import the workbook

Azure Portal → Microsoft Sentinel → **Workbooks → Add workbook → Edit → Advanced Editor**:
1. Paste the contents of `ZPAUserActivity.workbook`.
2. Apply → Save → name it "ZPA User Activity".

---

## Step 7 — Validate

Allow 5–10 minutes after enabling the Zscaler feed for the first events to land. Then run:

```kusto
// raw ingest sanity check
ZPA_CL
| where TimeGenerated > ago(15m)
| summarize rows=count(), latest=max(TimeGenerated)

// parsed event check
ZPAUserActivity
| where LogTimestamp > ago(15m)
| project LogTimestamp, Username, Application, Policy, PolicyProcessingTime, ClientCountryCode, ZENTotalBytesTxClient
| top 10 by LogTimestamp desc
```

Expected: rows appearing within 1–3 minutes of real user activity, with fields populated (Username, Application, Policy, byte counters, etc.).

---

## Notes

- The DCR's **immutable ID** is preserved across redeploys of the same stack, so the `api_url` in the Zscaler portal stays valid — no Zscaler reconfig needed when you update the bicep.
- The bicep can be redeployed safely; the `ZPA_CL` table preserves any auto-generated `*_s` / `*_d` columns from a prior MMA/syslog deployment.
- If you already have a `ZPA_CL` table with a different retention you want to keep, pass `retentionInDays=<your-value>` to the bicep deploy — the deploy will set the table to whatever value you pass, on every run.

---

## Troubleshooting

| Symptom | Likely cause |
|---|---|
| HTTP 403 from Zscaler feed test | App Registration missing **Monitoring Metrics Publisher** role on the DCR, or role still propagating (wait 60s) |
| Rows arrive but all fields empty (Message is ~1551 chars of `""`) | `.fof` at Zscaler side doesn't match the DCR stream — make sure you pasted the wrapped `{"sourcetype":"...","event":{...}}` form |
| `LogTimestamp` shows year 1970 / 1606 in the workbook | You're running an older `ZPAUserActivity()` function — re-save Step 5 with the latest content |
| No rows appear at all | Check the Zscaler portal's NSS Feed status page for delivery errors; verify the `api_url` matches and the OAuth token endpoint is correct for your tenant |
