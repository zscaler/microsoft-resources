 /* 
This creates both the DCR and DCE's needed to ingest data into Sentinel from Zscaler's Cloud NSS capability. 
Please replace any references to workspace names or resource groups with your deployment details.
Steps needed to deploy:
1. Create an App Registration as per the Deployment Guide or Storylane demo
2. Run this script from Azure CLI using the following command:

    az stack group create --name cloud-nss-cloudbranch-session --resource-group your-resource-group --template-file ./cloud-nss-cloudbranch-session.bicep --deny-settings-mode 'none' --action-on-unmanage deleteResources

  You will be prompted for parameters such as the resource group name and workspace id. You can enter ? and press enter to get a description of where to find each item.
  
  Alternatively, you can specify these parameters ahead of time by populating the cloud-nss-cloudbranch-session.bicepparams file and running the following command in Azure CLI to deploy:

    az stack group create --name cloud-nss-cloudbranch-session --resource-group your-resource-group --parameters cloud-nss-cloudbranch-session.bicepparam --deny-settings-mode 'none' --action-on-unmanage deleteResources

3. Go to the DCR this bicep template creates -> IAM -> Add this DCR as a Monitoring Metrics Publisher for the App Registration you created earlier.
4. Configure your Cloud NSS feed in the Zscaler Portal. You can retrieve the feed API URL using the following command in Azure CLI:

    az stack group show -g your-resource-group -n cloud-nss-cloudbranch-session --query outputs.api_url

5. If you ever need to delete the deployment, you can run the following command from Azure CLI:

    az stack group delete --name cloud-nss-cloudbranch-session --resource-group your-resource-group --delete-resources

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
      'Custom-nss_cloudbranch-session_CL': {
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
	  name: 'rt'
	  type: 'string'
	}
	{
	  name: 'dtz'
	  type: 'string'
	}
	{
	  name: 'dhost'
	  type: 'string'
	}
	{
	  name: 'src'
	  type: 'string'
	}
	{
	  name: 'spt'
	  type: 'string'
	}
	{
	  name: 'dst'
	  type: 'string'
	}
	{
	  name: 'dpt'
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
	  name: 'deviceCustomNumber1'
	  type: 'string'
	}
	{
	  name: 'deviceCustomNumber1Label'
	  type: 'string'
	}
	{
	  name: 'deviceCustomNumber2'
	  type: 'string'
	}
	{
	  name: 'deviceCustomNumber2Label'
	  type: 'string'
	}
	{
	  name: 'deviceCustomNumber3'
	  type: 'string'
	}
	{
	  name: 'deviceCustomNumber3Label'
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
	  name: 'deviceCustomString6Label'
	  type: 'string'
	}
	{
	  name: 'gw_dst_ip'
	  type: 'string'
	}
	{
	  name: 'deviceCustomString1'
	  type: 'string'
	}
	{
	  name: 'deviceCustomString1Label'
	  type: 'string'
	}
	{
	  name: 'srv_src_ip'
	  type: 'string'
	}
	{
	  name: 'srv_src_port'
	  type: 'string'
	}
	{
	  name: 'srv_ip_country'
	  type: 'string'
	}
	{
	  name: 'session_duration'
	  type: 'string'
	}
	{
	  name: 'cnt'
	  type: 'string'
	}
	{
	  name: 'num_aggr_sess'
	  type: 'string'
	}
	{
	  name: 'aggrname'
	  type: 'string'
	}
	{
	  name: 'rdrrulename'
	  type: 'string'
	}
	{
	  name: 'ordrrulename'
	  type: 'string'
	}
	{
	  name: 'self_rulename'
	  type: 'string'
	}
	{
	  name: 'oself_rulename'
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
	  name: 'nw_service'
	  type: 'string'
	}
	{
	  name: 'proto'
	  type: 'string'
	}
	{
	  name: 'srv_nw_protocol'
	  type: 'string'
	}
	{
	  name: 'zia_gw_protocol'
	  type: 'string'
	}
	{
	  name: 'app'
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
	  name: 'location'
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
	  name: 'Severity'
	  type: 'string'
	}
	{
	  name: 'deviceEventClassId'
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
        'Custom-nss_cloudbranch-session_CL'
      ]
      destinations: [
        workspaceId
      ]
        transformKql: 'source | project TimeGenerated, DeviceVendor=tostring(vendor), DeviceProduct=tostring(product), DeviceVersion=tostring(version), DeviceAction=tostring(act), ReceiptTime=tostring(rt), DeviceTimeZone=tostring(dtz), DestinationHostName=tostring(dhost), SourceIP=tostring(src), SourcePort=toint(spt), DestinationIP=tostring(dst), DestinationPort=toint(dpt), EventCount=toint(cnt), ReceivedBytes=tolong(in_bytes), SentBytes=tolong(out_bytes), Protocol=tostring(proto), ApplicationProtocol=tostring(app), DeviceName=tostring(dvchost), LogSeverity=tostring(Severity), DeviceEventClassID=tostring(deviceEventClassId), Activity=tostring(name), AdditionalExtensions = strcat("end=",end,";deviceCustomString2=",deviceCustomString2,";deviceCustomString2Label=",deviceCustomString2Label,";deviceCustomString3=",deviceCustomString3,";deviceCustomString3Label=",deviceCustomString3Label,";deviceCustomNumber1=",deviceCustomNumber1,";deviceCustomNumber1Label=",deviceCustomNumber1Label,";deviceCustomNumber2=",deviceCustomNumber2,";deviceCustomNumber2Label=",deviceCustomNumber2Label,";deviceCustomNumber3=",deviceCustomNumber3,";deviceCustomNumber3Label=",deviceCustomNumber3Label,";deviceCustomString4=",deviceCustomString4,";deviceCustomString4Label=",deviceCustomString4Label,";deviceCustomString5=",deviceCustomString5,";deviceCustomString5Label=",deviceCustomString5Label,";deviceCustomString6=",deviceCustomString6,";deviceCustomString6Label=",deviceCustomString6Label,";gw_dst_ip=",gw_dst_ip,";deviceCustomString1=",deviceCustomString1,";deviceCustomString1Label=",deviceCustomString1Label,";srv_src_ip=",srv_src_ip,";srv_src_port=",srv_src_port,";srv_ip_country=",srv_ip_country,";session_duration=",session_duration,";num_aggr_sess=",num_aggr_sess,";aggrname=",aggrname,";rdrrulename=",rdrrulename,";ordrrulename=",ordrrulename,";self_rulename=",self_rulename,";oself_rulename=",oself_rulename,";nw_service=",nw_service,";srv_nw_protocol=",srv_nw_protocol,";zia_gw_protocol=",zia_gw_protocol,";vm_name=",vm_name,";group_name=",group_name,";region_name=",region_name,";location=",location,";platform_name=",platform_name,";platformgeo_name=",platformgeo_name,";account_id=",account_id)'

        outputStream: 'Microsoft-CommonSecurityLog'
      }
  
      // 
    ]
  }
  location: location
  name: dcrName
}

// Store feed api url in template output
output api_url string = '${dce.properties.logsIngestion.endpoint}/dataCollectionRules/${dcr.properties.immutableId}/streams/Custom-nss_cloudbranch-session_CL?api-version=2021-11-01-preview'
