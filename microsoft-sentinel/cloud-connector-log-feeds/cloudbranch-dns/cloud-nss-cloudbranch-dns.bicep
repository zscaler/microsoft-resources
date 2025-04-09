 /* 
This creates both the DCR and DCE's needed to ingest data into Sentinel from Zscaler's Cloud NSS capability. 
Please replace any references to workspace names or resource groups with your deployment details.
Steps needed to deploy:
1. Create an App Registration as per the Deployment Guide or Storylane demo
2. Run this script from Azure CLI using the following command:

    az stack group create --name cloud-nss-cloudbranch-dns --resource-group your-resource-group --template-file ./cloud-nss-cloudbranch-dns.bicep --deny-settings-mode 'none' --action-on-unmanage deleteResources

  You will be prompted for parameters such as the resource group name and workspace id. You can enter ? and press enter to get a description of where to find each item.
  
  Alternatively, you can specify these parameters ahead of time by populating the cloud-nss-cloudbranch-dns.bicepparams file and running the following command in Azure CLI to deploy:

    az stack group create --name cloud-nss-cloudbranch-dns --resource-group your-resource-group --parameters cloud-nss-cloudbranch-dns.bicepparam --deny-settings-mode 'none' --action-on-unmanage deleteResources

3. Go to the DCR this bicep template creates -> IAM -> Add this DCR as a Monitoring Metrics Publisher for the App Registration you created earlier.
4. Configure your Cloud NSS feed in the Zscaler Portal. You can retrieve the feed API URL using the following command in Azure CLI:

    az stack group show -g your-resource-group -n cloud-nss-cloudbranch-dns --query outputs.api_url

5. If you ever need to delete the deployment, you can run the following command from Azure CLI:

    az stack group delete --name cloud-nss-cloudbranch-dns --resource-group your-resource-group --delete-resources

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
      'Custom-nss_cloudbranch-dns_CL': {
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
	  name: 'end'
	  type: 'string'
	}
	{
	  name: 'dtz'
	  type: 'string'
	}
	{
	  name: 'in_bytes'
	  type: 'string'
	}
	{
	  name: 'out_bytes'
	  type: 'string'
	}
	{
	  name: 'src'
	  type: 'string'
	}
	{
	  name: 'cn1Label'
	  type: 'string'
	}
	{
	  name: 'cn1'
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
	  name: 'recordid'
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
	  name: 'destinationDnsDomain'
	  type: 'string'
	}
	{
	  name: 'odom_str'
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
	  name: 'oresp_val_str'
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
	  name: 'dpt'
	  type: 'string'
	}
	{
	  name: 'cnt'
	  type: 'string'
	}
	{
	  name: 'proto'
	  type: 'string'
	}
	{
	  name: 'FlexString1Label'
	  type: 'string'
	}
	{
	  name: 'FlexString1'
	  type: 'string'
	}
	{
	  name: 'FlexString2Label'
	  type: 'string'
	}
	{
	  name: 'FlexString2'
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
	  name: 'region_name'
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
	  name: 'account_id'
	  type: 'string'
	}
	{
	  name: 'dst'
	  type: 'string'
	}
	{
	  name: 'res_action'
	  type: 'string'
	}
	{
	  name: 'deviceEventClassId'
	  type: 'string'
	}
	{
	  name: 'Severity'
	  type: 'string'
	}
	{
	  name: 'name'
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
        'Custom-nss_cloudbranch-dns_CL'
      ]
      destinations: [
        workspaceId
      ]
        transformKql: 'source | project TimeGenerated, DeviceVendor=tostring(vendor), DeviceProduct=tostring(product), DeviceVersion=tostring(version), DeviceAction=tostring(act), DeviceTimeZone=tostring(dtz), ReceivedBytes=tolong(in_bytes), SentBytes=tolong(out_bytes), SourceIP=tostring(src), DeviceCustomNumber1Label=tostring(cn1Label), DeviceCustomNumber1=toint(cn1), DeviceCustomString1Label=tostring(cs1Label), DeviceCustomString1=tostring(cs1), DeviceCustomString2Label=tostring(cs2Label), DeviceCustomString2=tostring(cs2), DestinationDnsDomain=tostring(destinationDnsDomain), DeviceCustomString3Label=tostring(cs3Label), DeviceCustomString3=tostring(cs3), DeviceCustomString4Label=tostring(cs4Label), DeviceCustomString4=tostring(cs4), DeviceCustomString5Label=tostring(cs5Label), DeviceCustomString5=tostring(cs5), DestinationPort=toint(dpt), EventCount=toint(cnt), Protocol=tostring(proto), DeviceName=tostring(dvchost), DestinationIP=tostring(dst), DeviceEventClassID=tostring(deviceEventClassId), LogSeverity=tostring(Severity), Activity=tostring(name), AdditionalExtensions = strcat("end=",end,";recordid=",recordid,";odom_str=",odom_str,";oresp_val_str=",oresp_val_str,";FlexString1Label=",FlexString1Label,";FlexString1=",FlexString1,";FlexString2Label=",FlexString2Label,";FlexString2=",FlexString2,";vm_name3=",vm_name,";group_name=",group_name,";region_name=",region_name,";platform_name=",platform_name,";platformgeo_name=",platformgeo_name,";account_id=",account_id,";res_action=",res_action)'

        outputStream: 'Microsoft-CommonSecurityLog'
      }
  
      // 
    ]
  }
  location: location
  name: dcrName
}

// Store feed api url in template output
output api_url string = '${dce.properties.logsIngestion.endpoint}/dataCollectionRules/${dcr.properties.immutableId}/streams/Custom-nss_cloudbranch-dns_CL?api-version=2021-11-01-preview'
