/*
This creates the DCE, DCR, and ZPA_CL custom table needed to ingest ZPA User Activity logs
into Sentinel via Zscaler's Cloud NSS Log Ingestion API path.

The DCR transform reconstructs the incoming Format-2 JSON into the ZPA_CL.Message column so
that the existing ZPAUserActivity() KQL function (which expects Message to contain the full
event JSON) works without modification. This means the same function and workbooks serve both
the AMA/syslog VM pipeline and the Log Ingestion API pipeline.

Deployment steps:
1. Create an App Registration as per the Deployment Guide.
2. Deploy:

    az stack group create --name cloud-nss-zpa-useractivity --resource-group <rg> --template-file ./cloud-nss-zpa-useractivity.bicep --deny-settings-mode 'none' --action-on-unmanage deleteResources

   Or with .bicepparam:

    az stack group create --name cloud-nss-zpa-useractivity --resource-group <rg> --parameters cloud-nss-zpa-useractivity.bicepparam --deny-settings-mode 'none' --action-on-unmanage deleteResources

3. Grant the App Registration 'Monitoring Metrics Publisher' on the created DCR.
4. Retrieve the ingest URL:

    az stack group show -g <rg> -n cloud-nss-zpa-useractivity --query outputs.api_url

5. Configure the ZPA User Activity Cloud NSS feed in the Zscaler portal using the .fof
   sample committed alongside this bicep.
*/

@description('Resource group containing the Log Analytics workspace')
param resourceGroup string
@description('Name of the Log Analytics workspace')
param workspaceName string
@description('Workspace location, e.g. australiaeast')
param location string
@description('Subscription ID hosting the workspace')
param subscriptionId string
@description('Workspace customer ID (GUID under workspace -> Overview -> Workspace ID)')
param workspaceId string
@description('Name of the Data Collection Endpoint to create')
param dceName string
@description('Name of the Data Collection Rule to create')
param dcrName string
@description('Retention in days for ZPA_CL. Applied on every deploy — pass the current value on a redeploy to preserve it.')
param retentionInDays int = 90

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: workspaceName
}

// ZPA_CL custom table. The PUT only adjusts the declared base columns + retention + plan;
// any extra suffix columns (e.g. *_s, *_d created by a prior MMA/syslog ingestion path) are
// preserved by the Log Analytics tables API.
resource zpaTable 'Microsoft.OperationalInsights/workspaces/tables@2022-10-01' = {
  parent: workspace
  name: 'ZPA_CL'
  properties: {
    schema: {
      name: 'ZPA_CL'
      columns: [
        { name: 'TimeGenerated', type: 'datetime' }
        { name: 'Message', type: 'string' }
        { name: 'SourceSystem', type: 'string' }
        { name: 'RawData', type: 'string' }
        { name: 'ManagementGroupName', type: 'string' }
        { name: 'Computer', type: 'string' }
      ]
    }
    retentionInDays: retentionInDays
    plan: 'Analytics'
  }
}

resource dce 'Microsoft.Insights/dataCollectionEndpoints@2022-06-01' = {
  name: dceName
  location: location
  properties: {
    configurationAccess: {}
    logsIngestion: {}
    networkAcls: {
      publicNetworkAccess: 'Enabled'
    }
  }
}

resource dcr 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: dcrName
  location: location
  properties: {
    dataCollectionEndpointId: dce.id
    streamDeclarations: {
      // The Cloud NSS Format-2 .fof wraps each event as {"sourcetype":"...","event":{...}}.
      // The DCR receives that wrapped shape, so the stream has two columns matching the
      // outer object. The transformKql below unwraps `event` into Message — keeping the
      // .fof itself in the standard Zscaler-portal-generated form (no flattening required
      // at the source).
      'Custom-ZPAUserActivity_CL': {
        columns: [
          { name: 'sourcetype', type: 'string' }
          { name: 'event', type: 'dynamic' }
        ]
      }
    }
    dataSources: {}
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: resourceId(subscriptionId, resourceGroup, 'microsoft.operationalinsights/workspaces', workspaceName)
          name: workspaceId
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Custom-ZPAUserActivity_CL'
        ]
        destinations: [
          workspaceId
        ]
        // Unwrap the Format-2 `event` object into the Message column so the existing
        // ZPAUserActivity() function (which parse_json's Message) keeps working identically
        // across the VM/syslog and Log Ingestion API pipelines. TimeGenerated derives from
        // event.LogTimestamp — Cloud NSS emits this as Unix epoch SECONDS (10 digits) for
        // ZPA UserActivity, NOT milliseconds. Verified against live data 2026-05-26.
        transformKql: 'source | extend Message = tostring(event) | project TimeGenerated = iff(isempty(tostring(event.LogTimestamp)), now(), datetime(1970-01-01) + tolong(event.LogTimestamp) * 1s), Message'
        outputStream: 'Custom-ZPA_CL'
      }
    ]
  }
  dependsOn: [
    zpaTable
  ]
}

output api_url string = '${dce.properties.logsIngestion.endpoint}/dataCollectionRules/${dcr.properties.immutableId}/streams/Custom-ZPAUserActivity_CL?api-version=2023-01-01'
output dcr_resource_id string = dcr.id
