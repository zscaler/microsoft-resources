 /* 
This creates both the DCR and DCE's needed to ingest data into Sentinel from Zscaler's Cloud NSS capability. 
Please replace any references to workspace names or resource groups with your deployment details.
Steps needed to deploy:
1. Create an App Registration as per the Deployment Guide or Storylane demo
2. Run this script from Azure CLI using the following command:

    az stack group create --name cloud-nss-endpointdlp --resource-group <resource group containing your log analytics workspace> --template-file ./cloud-nss-endpointdlp.bicep --deny-settings-mode 'none' --action-on-unmanage deleteResources

  You will be prompted for parameters such as the resource group name and workspace id. You can enter ? and press enter to get a description of where to find each item. 
  
  Alternatively, you can specify these parameters ahead of time by populating the cloud-nss-endpointdlp.bicepparams file and running the following command in Azure CLI to deploy:

    az stack group create --name cloud-nss-endpointdlp --resource-group <resource group containing your log analytics workspace> --parameters cloud-nss-endpointdlp.bicepparam --deny-settings-mode 'none' --action-on-unmanage deleteResources

3. Go to the DCR this bicep template creates -> IAM -> Add this DCR as a Monitoring Metrics Publisher for the App Registration you created earlier.
4. Configure your Cloud NSS feed in the Zscaler Portal. You can retrieve the feed API URL using the following command in Azure CLI:

    az stack group show -g <resource group containing your log analytics workspace> -n cloud-nss-endpointdlp --query outputs.api_url

5. If you ever need to delete the deployment, you can run the following command from Azure CLI:

    az stack group delete --name cloud-nss-endpointdlp --resource-group <resource group containing your log analytics workspace> --delete-resources

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
      'Custom-nss_endpointdlp_CL': {
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
	  name: 'Severity'
	  type: 'string'
	}
	{
	  name: 'name'
	  type: 'string'
	}
	{
	  name: 'rt'
	  type: 'string'
	}
	{
	  name: 'deviceCustomDate1Label'
	  type: 'string'
	}
	{
	  name: 'deviceCustomDate1'
	  type: 'string'
	}
	{
	  name: 'deviceCustomDate2Label'
	  type: 'string'
	}
	{
	  name: 'deviceCustomDate2'
	  type: 'string'
	}
	{
	  name: 'dtz'
	  type: 'string'
	}
	{
	  name: 'deviceCustomNumber1Label'
	  type: 'string'
	}
	{
	  name: 'cn1'
	  type: 'string'
	}
	{
	  name: 'deviceCustomNumber2Label'
	  type: 'string'
	}
	{
	  name: 'cn2'
	  type: 'string'
	}
	{
	  name: 'deviceCustomNumber3Label'
	  type: 'string'
	}
	{
	  name: 'cn3'
	  type: 'string'
	}
	{
	  name: 'externalId'
	  type: 'string'
	}
	{
	  name: 'scanned_bytes'
	  type: 'string'
	}
	{
	  name: 'dlpidentifier'
	  type: 'string'
	}
	{
	  name: 'suser'
	  type: 'string'
	}
	{
	  name: 'ouser'
	  type: 'string'
	}
	{
	  name: 'department'
	  type: 'string'
	}
	{
	  name: 'odepartment'
	  type: 'string'
	}
	{
	  name: 'devicename'
	  type: 'string'
	}
	{
	  name: 'odevicename'
	  type: 'string'
	}
	{
	  name: 'devicetype'
	  type: 'string'
	}
	{
	  name: 'deviceostype'
	  type: 'string'
	}
	{
	  name: 'deviceplatform'
	  type: 'string'
	}
	{
	  name: 'deviceosversion'
	  type: 'string'
	}
	{
	  name: 'devicemodel'
	  type: 'string'
	}
	{
	  name: 'deviceappversion'
	  type: 'string'
	}
	{
	  name: 'deviceowner'
	  type: 'string'
	}
	{
	  name: 'odeviceowner'
	  type: 'string'
	}
	{
	  name: 'dvchost'
	  type: 'string'
	}
	{
	  name: 'odevicehostname'
	  type: 'string'
	}
	{
	  name: 'datacenter'
	  type: 'string'
	}
	{
	  name: 'datacentercity'
	  type: 'string'
	}
	{
	  name: 'datacentercountry'
	  type: 'string'
	}
	{
	  name: 'dsttype'
	  type: 'string'
	}
	{
	  name: 'filedoctype'
	  type: 'string'
	}
	{
	  name: 'filedstpath'
	  type: 'string'
	}
	{
	  name: 'fileHash'
	  type: 'string'
	}
	{
	  name: 'filesha'
	  type: 'string'
	}
	{
	  name: 'filePath'
	  type: 'string'
	}
	{
	  name: 'filetypecategory'
	  type: 'string'
	}
	{
	  name: 'fileType'
	  type: 'string'
	}
	{
	  name: 'itemdstname'
	  type: 'string'
	}
	{
	  name: 'itemname'
	  type: 'string'
	}
	{
	  name: 'itemsrcname'
	  type: 'string'
	}
	{
	  name: 'itemtype'
	  type: 'string'
	}
	{
	  name: 'ofiledstpath'
	  type: 'string'
	}
	{
	  name: 'ofilesrcpath'
	  type: 'string'
	}
	{
	  name: 'oitemdstname'
	  type: 'string'
	}
	{
	  name: 'oitemname'
	  type: 'string'
	}
	{
	  name: 'oitemsrcname'
	  type: 'string'
	}
	{
	  name: 'sourceServiceName'
	  type: 'string'
	}
	{
	  name: 'act'
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
	  name: 'cs6Label'
	  type: 'string'
	}
	{
	  name: 'cs6'
	  type: 'string'
	}
	{
	  name: 'dlpdictnames'
	  type: 'string'
	}
	{
	  name: 'dlpengnames'
	  type: 'string'
	}
	{
	  name: 'expectedaction'
	  type: 'string'
	}
	{
	  name: 'deviceEventClassId'
	  type: 'string'
	}
	{
	  name: 'odlpdictnames'
	  type: 'string'
	}
	{
	  name: 'odlpengnames'
	  type: 'string'
	}
	{
	  name: 'ootherrulelabels'
	  type: 'string'
	}
	{
	  name: 'otherrulelabels'
	  type: 'string'
	}
	{
	  name: 'otriggeredrulelabel'
	  type: 'string'
	}
	{
	  name: 'agentSeverity'
	  type: 'string'
	}
	{
	  name: 'triggeredrulelabel'
	  type: 'string'
	}
	{
	  name: 'zdpmode'
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
        'Custom-nss_endpointdlp_CL'
      ]
      destinations: [
        workspaceId
      ]
        transformKql: 'source | project TimeGenerated, DeviceVendor=tostring(vendor), DeviceProduct=tostring(product), DeviceVersion=tostring(version), LogSeverity=tostring(Severity), Activity=tostring(name), ReceiptTime=tostring(rt), DeviceCustomDate1Label=tostring(deviceCustomDate1Label), DeviceCustomDate1=tostring(deviceCustomDate1), DeviceCustomDate2Label=tostring(deviceCustomDate2Label), DeviceCustomDate2=tostring(deviceCustomDate2), DeviceTimeZone=tostring(dtz), DeviceCustomNumber1=toint(cn1), DeviceCustomNumber2=toint(cn2), DeviceCustomNumber3=toint(cn3), ExternalID=toint(externalId), SourceUserName=tostring(suser), DeviceName=tostring(dvchost), FileHash=tostring(fileHash), FilePath=tostring(filePath), FileType=tostring(fileType), SourceServiceName=tostring(sourceServiceName), DeviceAction=tostring(act), DeviceCustomString1Label=tostring(cs1Label), DeviceCustomString1=tostring(cs1), DeviceCustomString2Label=tostring(cs2Label), DeviceCustomString2=tostring(cs2), DeviceCustomString3Label=tostring(cs3Label), DeviceCustomString3=tostring(cs3), DeviceCustomString4Label=tostring(cs4Label), DeviceCustomString4=tostring(cs4), DeviceCustomString5Label=tostring(cs5Label), DeviceCustomString5=tostring(cs5), DeviceCustomString6Label=tostring(cs6Label), DeviceCustomString6=tostring(cs6), DeviceEventClassID=tostring(deviceEventClassId), AdditionalExtensions = strcat("deviceCustomNumber1Label=",deviceCustomNumber1Label,";deviceCustomNumber2Label=",deviceCustomNumber2Label,";deviceCustomNumber3Label=",deviceCustomNumber3Label,";scanned_bytes=",scanned_bytes,";dlpidentifier=",dlpidentifier,";ouser=",ouser,";department=",department,";odepartment=",odepartment,";devicename=",devicename,";odevicename=",odevicename,";devicetype=",devicetype,";deviceostype=",deviceostype,";deviceplatform=",deviceplatform,";deviceosversion=",deviceosversion,";devicemodel=",devicemodel,";deviceappversion=",deviceappversion,";deviceowner=",deviceowner,";odeviceowner=",odeviceowner,";odevicehostname=",odevicehostname,";datacenter=",datacenter,";datacentercity=",datacentercity,";datacentercountry=",datacentercountry,";dsttype=",dsttype,";filedoctype=",filedoctype,";filedstpath=",filedstpath,";filesha=",filesha,";filetypecategory=",filetypecategory,";itemdstname=",itemdstname,";itemname=",itemname,";itemsrcname=",itemsrcname,";itemtype=",itemtype,";ofiledstpath=",ofiledstpath,";ofilesrcpath=",ofilesrcpath,";oitemdstname=",oitemdstname,";oitemname=",oitemname,";oitemsrcname=",oitemsrcname,";dlpdictnames=",dlpdictnames,";dlpengnames=",dlpengnames,";expectedaction=",expectedaction,";odlpdictnames=",odlpdictnames,";odlpengnames=",odlpengnames,";ootherrulelabels=",ootherrulelabels,";otherrulelabels=",otherrulelabels,";otriggeredrulelabel=",otriggeredrulelabel,";agentSeverity=",agentSeverity,";triggeredrulelabel=",triggeredrulelabel,";zdpmode=",zdpmode)'

        outputStream: 'Microsoft-CommonSecurityLog'
      }
  
      // 
    ]
  }
  location: location
  name: dcrName
}

// Store feed api url in template output
output api_url string = '${dce.properties.logsIngestion.endpoint}/dataCollectionRules/${dcr.properties.immutableId}/streams/Custom-nss_endpointdlp_CL?api-version=2021-11-01-preview'
