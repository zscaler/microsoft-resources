 /* 
This creates both the DCR and DCE's needed to ingest data into Sentinel from Zscaler's Cloud NSS capability. 
Please replace any references to workspace names or resource groups with your deployment details.
Steps needed to deploy:
1. Create an App Registration as per the Deployment Guide or Storylane demo
2. Run this script from Azure CLI using the following command:

    az stack group create --name cloud-nss-cloudbranch-event --resource-group your-resource-group --template-file ./cloud-nss-cloudbranch-event.bicep --deny-settings-mode 'none' --action-on-unmanage deleteResources

  You will be prompted for parameters such as the resource group name and workspace id. You can enter ? and press enter to get a description of where to find each item.
  
  Alternatively, you can specify these parameters ahead of time by populating the cloud-nss-cloudbranch-event.bicepparams file and running the following command in Azure CLI to deploy:

    az stack group create --name cloud-nss-cloudbranch-event --resource-group your-resource-group --parameters cloud-nss-cloudbranch-event.bicepparam --deny-settings-mode 'none' --action-on-unmanage deleteResources

3. Go to the DCR this bicep template creates -> IAM -> Add this DCR as a Monitoring Metrics Publisher for the App Registration you created earlier.
4. Configure your Cloud NSS feed in the Zscaler Portal. You can retrieve the feed API URL using the following command in Azure CLI:

    az stack group show -g your-resource-group -n cloud-nss-cloudbranch-event --query outputs.api_url

5. If you ever need to delete the deployment, you can run the following command from Azure CLI:

    az stack group delete --name cloud-nss-cloudbranch-event --resource-group your-resource-group --delete-resources

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
      'Custom-nss_cloudbranch-event_CL': {
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
	  name: 'act'
	  type: 'string'
	}
	{
	  name: 'cat'
	  type: 'string'
	}
	{
	  name: 'deviceEventClassId'
	  type: 'string'
	}
	{
	  name: 'deviceCustomDate2'
	  type: 'string'
	}
	{
	  name: 'deviceCustomDate2Label'
	  type: 'string'
	}
	{
	  name: 'deviceCustomDate1'
	  type: 'string'
	}
	{
	  name: 'deviceCustomDate1Label'
	  type: 'string'
	}
	{
	  name: 'flexDate1'
	  type: 'string'
	}
	{
	  name: 'flexDate1Label'
	  type: 'string'
	}
	{
	  name: 'dtz'
	  type: 'string'
	}
	{
	  name: 'rt'
	  type: 'string'
	}
	{
	  name: 'company'
	  type: 'string'
	}
	{
	  name: 'location'
	  type: 'string'
	}
	{
	  name: 'dvchost'
	  type: 'string'
	}
	{
	  name: 'vm_name'
	  type: 'string'
	}
	{
	  name: 'group_name'
	  type: 'string'
	}
	{
	  name: 'platform_name'
	  type: 'string'
	}
	{
	  name: 'platformgeo_name'
	  type: 'string'
	}
	{
	  name: 'region_name'
	  type: 'string'
	}
	{
	  name: 'connector_type'
	  type: 'string'
	}
	{
	  name: 'deviceCustomString2'
	  type: 'string'
	}
	{
	  name: 'deviceCustomString2Label'
	  type: 'string'
	}
	{
	  name: 'deviceCustomString3'
	  type: 'string'
	}
	{
	  name: 'deviceCustomString3Label'
	  type: 'string'
	}
	{
	  name: 'deviceCustomString4'
	  type: 'string'
	}
	{
	  name: 'deviceCustomString4Label'
	  type: 'string'
	}
	{
	  name: 'deviceCustomString5'
	  type: 'string'
	}
	{
	  name: 'deviceCustomString5Label'
	  type: 'string'
	}
	{
	  name: 'deviceCustomString6'
	  type: 'string'
	}
	{
	  name: 'account_id'
	  type: 'string'
	}
	{
	  name: 'name'
	  type: 'string'
	}
	{
	  name: 'Severity'
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
        'Custom-nss_cloudbranch-event_CL'
      ]
      destinations: [
        workspaceId
      ]
        transformKql: 'source | project TimeGenerated, DeviceVendor=tostring(vendor), DeviceProduct=tostring(product), DeviceVersion=tostring(version), DeviceAction=tostring(act), DeviceEventCategory=tostring(cat), DeviceEventClassID=tostring(deviceEventClassId), DeviceCustomDate2=tostring(deviceCustomDate2), DeviceCustomDate2Label=tostring(deviceCustomDate2Label), DeviceCustomDate1=tostring(deviceCustomDate1), DeviceCustomDate1Label=tostring(deviceCustomDate1Label), FlexDate1=tostring(flexDate1), FlexDate1Label=tostring(flexDate1Label), DeviceTimeZone=tostring(dtz), ReceiptTime=tostring(rt), DeviceName=tostring(dvchost), Activity=tostring(name), LogSeverity=tostring(Severity), AdditionalExtensions = strcat("company=",company,";location=",location,";vm_name=",vm_name,";group_name=",group_name,";platform_name=",platform_name,";platformgeo_name=",platformgeo_name,";region_name=",region_name,";connector_type=",connector_type,";deviceCustomString2=",deviceCustomString2,";deviceCustomString2Label=",deviceCustomString2Label,";deviceCustomString3=",deviceCustomString3,";deviceCustomString3Label=",deviceCustomString3Label,";deviceCustomString4=",deviceCustomString4,";deviceCustomString4Label=",deviceCustomString4Label,";deviceCustomString5=",deviceCustomString5,";deviceCustomString5Label=",deviceCustomString5Label,";deviceCustomString6=",deviceCustomString6,";account_id=",account_id)'

        outputStream: 'Microsoft-CommonSecurityLog'
      }
  
      // 
    ]
  }
  location: location
  name: dcrName
}

// Store feed api url in template output
output api_url string = '${dce.properties.logsIngestion.endpoint}/dataCollectionRules/${dcr.properties.immutableId}/streams/Custom-nss_cloudbranch-event_CL?api-version=2021-11-01-preview'
