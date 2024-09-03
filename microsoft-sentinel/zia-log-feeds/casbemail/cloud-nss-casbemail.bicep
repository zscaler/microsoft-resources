 /* 
This creates both the DCR and DCE's needed to ingest data into Sentinel from Zscaler's Cloud NSS capability. 
Please replace any references to workspace names or resource groups with your deployment details.
Steps needed to deploy:
1. Create an App Registration as per the Deployment Guide or Storylane demo
2. Run this script from Azure CLI using the following command:

    az stack group create --name cloud-nss-casbemail --resource-group <resource group containing your log analytics workspace> --template-file ./cloud-nss-casbemail.bicep --deny-settings-mode 'none' --action-on-unmanage deleteResources

  You will be prompted for parameters such as the resource group name and workspace id. You can enter ? and press enter to get a description of where to find each item.
  
  Alternatively, you can specify these parameters ahead of time by populating the cloud-nss-casbemail.bicepparams file and running the following command in Azure CLI to deploy:

    az stack group create --name cloud-nss-casbemail --resource-group <resource group containing your log analytics workspace> --parameters cloud-nss-casbemail.bicepparam --deny-settings-mode 'none' --action-on-unmanage deleteResources

3. Go to the DCR this bicep template creates -> IAM -> Add this DCR as a Monitoring Metrics Publisher for the App Registration you created earlier.
4. Configure your Cloud NSS feed in the Zscaler Portal. You can retrieve the feed API URL using the following command in Azure CLI:

    az stack group show -g <resource group containing your log analytics workspace> -n cloud-nss-casbemail --query outputs.api_url

5. If you ever need to delete the deployment, you can run the following command from Azure CLI:

    az stack group delete --name cloud-nss-casbemail --resource-group <resource group containing your log analytics workspace> --delete-resources

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
      'Custom-nss_casbemail_CL': {
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
	  name: 'deviceEventClassId'
	  type: 'string'
	}
	{
	  name: 'act'
	  type: 'string'
	}
	{
	  name: 'oexternalownername'
	  type: 'string'
	}
	{
	  name: 'companyid'
	  type: 'string'
	}
	{
	  name: 'dlpidentifier'
	  type: 'string'
	}
	{
	  name: 'epochtime'
	  type: 'string'
	}
	{
	  name: 'filedownloadtimems'
	  type: 'string'
	}
	{
	  name: 'filescantimems'
	  type: 'string'
	}
	{
	  name: 'msgsize'
	  type: 'string'
	}
	{
	  name: 'num_ext_recpts'
	  type: 'string'
	}
	{
	  name: 'num_int_recpts'
	  type: 'string'
	}
	{
	  name: 'deviceExternalId'
	  type: 'string'
	}
	{
	  name: 'repochtime'
	  type: 'string'
	}
	{
	  name: 'outcome'
	  type: 'string'
	}
	{
	  name: 'fname'
	  type: 'string'
	}
	{
	  name: 'fsize'
	  type: 'string'
	}
	{
	  name: 'fileType'
	  type: 'string'
	}
	{
	  name: 'fileHash'
	  type: 'string'
	}
	{
	  name: 'company'
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
	  name: 'department'
	  type: 'string'
	}
	{
	  name: 'dlpdictcount'
	  type: 'string'
	}
	{
	  name: 'dlpdictnames'
	  type: 'string'
	}
	{
	  name: 'dlpenginenames'
	  type: 'string'
	}
	{
	  name: 'externalownername'
	  type: 'string'
	}
	{
	  name: 'extrecptnames'
	  type: 'string'
	}
	{
	  name: 'intrecptnames'
	  type: 'string'
	}
	{
	  name: 'is_inbound'
	  type: 'string'
	}
	{
	  name: 'malware'
	  type: 'string'
	}
	{
	  name: 'malwareclass'
	  type: 'string'
	}
	{
	  name: 'messageid'
	  type: 'string'
	}
	{
	  name: 'oattchcomponentfilenames'
	  type: 'string'
	}
	{
	  name: 'odlpdictnames'
	  type: 'string'
	}
	{
	  name: 'odlpenginenames'
	  type: 'string'
	}
	{
	  name: 'oextrecptnames'
	  type: 'string'
	}
	{
	  name: 'ointrecptnames'
	  type: 'string'
	}
	{
	  name: 'omessageid'
	  type: 'string'
	}
	{
	  name: 'oowner'
	  type: 'string'
	}
	{
	  name: 'orulelabel'
	  type: 'string'
	}
	{
	  name: 'otenant'
	  type: 'string'
	}
	{
	  name: 'owner'
	  type: 'string'
	}
	{
	  name: 'rtime'
	  type: 'string'
	}
	{
	  name: 'rulelabel'
	  type: 'string'
	}
	{
	  name: 'ruletype'
	  type: 'string'
	}
	{
	  name: 'severity'
	  type: 'string'
	}
	{
	  name: 'tenant'
	  type: 'string'
	}
	{
	  name: 'threatname'
	  type: 'string'
	}
	{
	  name: 'tz'
	  type: 'string'
	}
	{
	  name: 'upload_doctypename'
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
        'Custom-nss_casbemail_CL'
      ]
      destinations: [
        workspaceId
      ]
        transformKql: 'source | project TimeGenerated, DeviceVendor=tostring(vendor), DeviceProduct=tostring(product), DeviceVersion=tostring(version), LogSeverity=tostring(Severity), Activity=tostring(name), DeviceEventClassID=tostring(deviceEventClassId), DeviceAction=tostring(act), deviceExternalId=tostring(deviceExternalId), EventOutcome=tostring(outcome), FileName=tostring(fname), FileSize=toint(fsize), FileType=tostring(fileType), FileHash=tostring(fileHash), AdditionalExtensions = strcat("oexternalownername=",oexternalownername,";companyid=",companyid,";dlpidentifier=",dlpidentifier,";epochtime=",epochtime,";filedownloadtimems=",filedownloadtimems,";filescantimems=",filescantimems,";msgsize=",msgsize,";num_ext_recpts=",num_ext_recpts,";num_int_recpts=",num_int_recpts,";repochtime=",repochtime,";company=",company,";datacenter=",datacenter,";datacentercity=",datacentercity,";datacentercountry=",datacentercountry,";department=",department,";dlpdictcount=",dlpdictcount,";dlpdictnames=",dlpdictnames,";dlpenginenames=",dlpenginenames,";externalownername=",externalownername,";extrecptnames=",extrecptnames,";intrecptnames=",intrecptnames,";is_inbound=",is_inbound,";malware=",malware,";malwareclass=",malwareclass,";messageid=",messageid,";oattchcomponentfilenames=",oattchcomponentfilenames,";odlpdictnames=",odlpdictnames,";odlpenginenames=",odlpenginenames,";oextrecptnames=",oextrecptnames,";ointrecptnames=",ointrecptnames,";omessageid=",omessageid,";oowner=",oowner,";orulelabel=",orulelabel,";otenant=",otenant,";owner=",owner,";rtime=",rtime,";rulelabel=",rulelabel,";ruletype=",ruletype,";severity=",severity,";tenant=",tenant,";threatname=",threatname,";tz=",tz,";upload_doctypename=",upload_doctypename)'

        outputStream: 'Microsoft-CommonSecurityLog'
      }
  
      // 
    ]
  }
  location: location
  name: dcrName
}

// Store feed api url in template output
output api_url string = '${dce.properties.logsIngestion.endpoint}/dataCollectionRules/${dcr.properties.immutableId}/streams/Custom-nss_casbemail_CL?api-version=2021-11-01-preview'
