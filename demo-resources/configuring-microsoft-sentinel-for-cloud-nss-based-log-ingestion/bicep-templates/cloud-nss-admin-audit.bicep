/* 
This creates both the DCR and DCE's needed to ingest data into Sentinel from Zscaler's Cloud NSS capability.
Steps needed to deploy:
1. Create an App Registration as per the Deployment Guide or Storylane demo
2. Run this script from Azure CLI using the following command:

  az stack group create --name cloud-nss-admin-audit --resource-group <resource group containing your log analytics workspace> --template-file ./cloud-nss-web.bicep --deny-settings-mode 'none'

  You will be prompted for parameters such as the resource group name and workspace id. You can enter ? and press enter to get a description of where to find each item.
  
  Alternatively, you can specify these parameters ahead of time by populating the cloud-nss-web.bicepparams file and running the following command in Azure CLI to deploy:

  az stack group create --name cloud-nss-admin-audit --resource-group rg-sentinel-cloud-admin-audit --parameters cloud-nss-admin-audit.bicepparam --deny-settings-mode 'none'

3. Go to the DCR this bicep template creates -> IAM -> Add this DCR as a Monitoring Metrics Publisher for the App Registration you created earlier.
4. Configure your Cloud NSS feed in the Zscaler Portal. You can retrieve the feed API URL using the following command in Azure CLI:

   az stack group show -g <resouce group containing your log analytics workspace> -n cloud-nss-admin-audit --query outputs.api_url

5. If you ever need to delete the deployment, you can run the following command from Azure CLI:

  az stack group delete --name cloud-nss-admin-audit --resource-group rg-sentinel-cloud-admin-audit --delete-resources

*/

// These resources need to be pre-configured
@description('Found under Log Analytics workspace -> your workspace -> Overview -> Resource group')
param resourceGroup string // Found under Log Analytics workspace -> your workspace -> Overview -> Resource group
@description('The name of your Log Analytics workspace')
param workspaceName string
@description('Found under Log Analytics workspace -> your workspace -> Overview -> JSON View -> location. I.e. australiaeast')
param location string
@description('Found under Log Analytics workspace -> your workspace -> Overview -> Subscription ID')
param subscriptionId string
@description('Found under Log Analytics workspace -> your workspace -> Overview -> Workspace ID')
param workspaceId string

// These resources are configured through bicep
@description('Name of Data Collection Endpoint the template will create')
param dceName string
@description('Name of the Data Collection Rule the template will create')
param dcrName string

resource dce 'Microsoft.Insights/dataCollectionEndpoints@2022-06-01' = {
  properties: {
    configurationAccess: {}
    logsIngestion: {}
    networkAcls: {
      publicNetworkAccess: 'Enabled'
    }
  }
  location: location
  name: dceName
}

resource dcr 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  properties: {
    dataCollectionEndpointId: dce.id
    streamDeclarations: {
      'Custom-nss_admin_audit_CL': {
        columns: [
          {
            name: 'sourcetype'
            type: 'string'
          }
          {
            name: 'TimeGenerated'
            type: 'datetime'
          }
          {
            name: 'vendor'
            type: 'string'
          }
          {
            name: 'product'
            type: 'string'
          }
          {
            name: 'version'
            type: 'string'
          }
          {
            name: 'deviceEventClassId'
            type: 'string'
          }
          {
            name: 'cat'
            type: 'string'
          }
          {
            name: 'severity'
            type: 'string'
          }
          {
            name: 'act'
            type: 'string'
          }
          {
            name: 'externalId'
            type: 'string'
          }
          {
            name: 'cs1Label'
            type: 'string'
          }
          {
            name: 'cs1'
            type: 'string'
          }        
          {
            name: 'cs2Label'
            type: 'string'
          }
          {
            name: 'cs2'
            type: 'string'
          }        
          {
            name: 'cs3Label'
            type: 'string'
          }
          {
            name: 'cs3'
            type: 'string'
          }        
          {
            name: 'cs4Label'
            type: 'string'
          }
          {
            name: 'cs4'
            type: 'string'
          }        
          {
            name: 'cs5Label'
            type: 'string'
          }
          {
            name: 'cs5'
            type: 'string'
          }
          {
            name: 'suser'
            type: 'string'
          }
          {
            name: 'src'
            type: 'string'
          }
          {
            name: 'outcome'
            type: 'string'
          }
          {
            name: 'reason'
            type: 'string'
          }
          {
            name: 'sourceServiceName'
            type: 'string'
          }     
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
          'Custom-nss_admin_audit_CL'
        ]
        destinations: [
          workspaceId
        ]
        transformKql: 'source | project TimeGenerated,DeviceVendor=tostring(vendor),DeviceProduct=tostring(product),DeviceVersion=tostring(version),DeviceEventClassID=tostring(deviceEventClassId),DeviceEventCategory=tostring(cat),LogSeverity=tostring(severity),DeviceAction=tostring(act),DeviceExternalID=tostring(externalId),DeviceCustomString1Label=tostring(cs1Label),DeviceCustomString1=tostring(cs1),DeviceCustomString2Label=tostring(cs2Label),DeviceCustomString2=tostring(cs2),DeviceCustomString3Label=tostring(cs3Label),DeviceCustomString3=tostring(cs3),DeviceCustomString4Label=tostring(cs4Label),DeviceCustomString4=tostring(cs4),DeviceCustomString5Label=tostring(cs5Label),DeviceCustomString5=tostring(cs5),SourceUserName=tostring(suser),SourceIP=tostring(src),EventOutcome=tostring(outcome),Reason=tostring(reason),SourceServiceName=tostring(sourceServiceName)\n'
        outputStream: 'Microsoft-CommonSecurityLog'
      }
    ]
  }
  location: location
  name: dcrName
}

// Store feed api url in template output
output api_url string = '${dce.properties.logsIngestion.endpoint}/dataCollectionRules/${dcr.properties.immutableId}/streams/Custom-nss_admin_audit_CL?api-version=2021-11-01-preview'
