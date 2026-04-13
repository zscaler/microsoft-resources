# Zscaler OAuth2 Authentication Playbook (v3.0)

This is a new version of the Zscaler OAuth2 Authentication module which supports both **OneAPI (ZIdentity)** and **Legacy (Azure AD / Entra ID)** authentication in a single deployment. Choose the mode that matches how your Zscaler tenant is configured.

We would love to get your feedback on this — please try it out and let us know how it goes.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fzscaler%2Fmicrosoft-resources%2Fmain%2Fmicrosoft-sentinel%2Fplaybooks%2FZscaler-Oauth2-Authentication%2Fazuredeploy.json)

---

## What's New

This playbook now supports two authentication modes in a single deployment. Choose the mode that matches how your Zscaler tenant is configured.

---

## OneAPI Mode (ZIdentity)

### What you need

1. Go to `https://<your-vanity>-admin.zslogin.net/iam/admin/api-clients`
2. Create an API client and activate it
3. Note the **Client ID** and **Client Secret**
4. Note your **vanity domain prefix** from the URL (e.g., `z-41181109`)

### Deploy with

| Parameter | Value |
|---|---|
| **OAuth Client Id** | Your client ID |
| **OAuth Client Secret** | Your client secret |
| **Zscaler Vanity Domain** | Your vanity prefix (e.g., `z-41181109`) |
| **OAuth Token Url** | *Leave empty* |
| **OAuth Scope** | *Leave empty* |

---

## Legacy Mode (Azure AD / Entra ID)

### What you need

1. Your **Client ID** from the ZIA API Client Application
2. Your **Client Secret** from the ZIA API Client Application
3. Your **OAuth2 token endpoint URL** from your Zscaler administrator
4. Your **OAuth2 scope** — the Application ID URI from your ZIA API Web Service Application appended with `/.default` (e.g., `api://c0636925-82fa-49e1-be49-72afb0a9fd59/.default`)

### Deploy with

| Parameter | Value |
|---|---|
| **OAuth Client Id** | Your client ID |
| **OAuth Client Secret** | Your client secret |
| **Zscaler Vanity Domain** | *Leave empty* |
| **OAuth Token Url** | Your full token endpoint URL |
| **OAuth Scope** | Your scope (e.g., `api://c0636925-.../.default`) |

---

## Post-Deployment Steps

After deploying the **auth playbook** and any **downstream playbooks** (LookupURL, LookupIP, BlockURL, etc.), you must authorize the API connections:

1. **Deploy the auth playbook first** using the Deploy to Azure button above
2. **Deploy any downstream playbooks** (e.g., Zscaler-Oauth2-LookupURL, Zscaler-Oauth2-BlockIP)
3. **Authorize the Sentinel API connection** for each downstream playbook:
   - In the Azure portal, navigate to the deployed Logic App
   - Go to **Development Tools** > **API Connections**
   - Click on the **MicrosoftSentinel** connection
   - Click **Edit API Connection**
   - Click **Authorize** and sign in
   - Click **Save**
4. **Grant Sentinel Responder role** to each downstream playbook's managed identity on your Log Analytics workspace:
   - Navigate to your **Log Analytics workspace**
   - Go to **Access control (IAM)** > **Add role assignment**
   - Select **Microsoft Sentinel Responder**
   - Assign to the downstream playbook's managed identity

Repeat steps 3-4 for each downstream playbook you deploy.

---

## Upgrading from v2.0

- **Same Client ID and Client Secret** — no changes needed
- **If your tenant is OneAPI-enabled:** Enter your vanity domain prefix in **Zscaler Vanity Domain** and clear the token URL and scope fields
- **If your tenant is legacy:** Keep using **OAuth Token Url** as before, and add your **OAuth Scope** value
- **No changes needed to downstream playbooks** (BlockURL, LookupIP, etc.) — they call the auth playbook the same way regardless of mode
