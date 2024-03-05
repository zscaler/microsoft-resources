// This creates both the DCR and DCE's needed to ingest data into Sentinel from Zscaler's Cloud NSS capability.
// Steps needed to deploy
// 1. Create an App Registration as per the DG/Storylane demo
// 2. To run this script install bicep (if not already installed) and run the following command - New-AzResourceGroupDeployment -ResourceGroupName "<resource group containing your log analytics workspace>" -TemplateFile "cloud-nss-web.bicep"
// 3. Go to the DCR this bicep template creates -> IAM -> Add this DCR as a Monitoring Metrics Publisher for the App Registration you created create.
// 4. Configure your Cloud NSS feed in the Zscaler Portal.

// These resources need to be pre-configured
param resoureGroup string = 'xxx' // Found under Log Analytics workspace -> your workspace -> Overview -> Location
param workspaceName string = 'xxx' // The name of your Log Analytics workspace
param location string = 'xxx' // Found under Log Analytics workspace -> your workspace -> Overview -> Location
param subscriptionId string = 'xxx' // Found under Log Analytics workspace -> your workspace -> Overview -> Subscription ID
param workspaceId string = 'xxx' // Found under Log Analytics workspace -> your workspace -> Overview -> Workspace ID

// These resources are configured through bicep
param dceName string = 'xxx'
param dcrName string = 'xxx'

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
    dataCollectionEndpointId: '/subscriptions/${subscriptionId}/resourceGroups/${resoureGroup}/providers/Microsoft.Insights/dataCollectionEndpoints/${dceName}'
    streamDeclarations: {
      'Custom-nss_web_CL': {
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
            name: 'act'
            type: 'string'
          }
          {
            name: 'reason'
            type: 'string'
          }
          {
            name: 'app'
            type: 'string'
          }
          {
            name: 'dhost'
            type: 'string'
          }
          {
            name: 'dst'
            type: 'string'
          }
          {
            name: 'src'
            type: 'string'
          }
          {
            name: 'sourceTranslatedAddress'
            type: 'string'
          }
          {
            name: 'in_bytes'
            type: 'string'
          }
          {
            name: 'out'
            type: 'string'
          }
          {
            name: 'request'
            type: 'string'
          }
          {
            name: 'requestContext'
            type: 'string'
          }
          {
            name: 'outcome'
            type: 'string'
          }
          {
            name: 'requestClientApplication'
            type: 'string'
          }
          {
            name: 'requestMethod'
            type: 'string'
          }
          {
            name: 'suser'
            type: 'string'
          }
          {
            name: 'spriv'
            type: 'string'
          }
          {
            name: 'externalId'
            type: 'string'
          }
          {
            name: 'fileType'
            type: 'string'
          }
          {
            name: 'destinationServiceName'
            type: 'string'
          }
          {
            name: 'cat'
            type: 'string'
          }
          {
            name: 'deviceDirection'
            type: 'string'
          }
          {
            name: 'cn1'
            type: 'string'
          }
          {
            name: 'cn1Label'
            type: 'string'
          }
          {
            name: 'cs1'
            type: 'string'
          }
          {
            name: 'cs1Label'
            type: 'string'
          }
          {
            name: 'cs2'
            type: 'string'
          }
          {
            name: 'cs2Label'
            type: 'string'
          }
          {
            name: 'cs3'
            type: 'string'
          }
          {
            name: 'cs3Label'
            type: 'string'
          }
          {
            name: 'cs4'
            type: 'string'
          }
          {
            name: 'cs4Label'
            type: 'string'
          }
          {
            name: 'cs5'
            type: 'string'
          }
          {
            name: 'cs5Label'
            type: 'string'
          }
          {
            name: 'cs6'
            type: 'string'
          }
          {
            name: 'cs6Label'
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
            name: 'urlclass'
            type: 'string'
          }
          {
            name: 'DeviceVendor'
            type: 'string'
          }
          {
            name: 'DeviceProduct'
            type: 'string'
          }
          {
            name: 'devicemodel'
            type: 'string'
          }
          {
            name: 'flexString1'
            type: 'string'
          }
          {
            name: 'flexString1Label'
            type: 'string'
          }
          {
            name: 'flexString2'
            type: 'string'
          }
          {
            name: 'flexString2Label'
            type: 'string'
          }
        ]
      }
    }
    dataSources: {}
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: '/subscriptions/${subscriptionId}/resourcegroups/${resoureGroup}/providers/microsoft.operationalinsights/workspaces/${workspaceName}'
          name: workspaceId
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Custom-nss_web_CL'
        ]
        destinations: [
          workspaceId
        ]
        transformKql: 'source | project TimeGenerated,\nDeviceCustomString1Label = tostring(cs1Label) , DeviceCustomString1 = tostring(cs1) ,\nDeviceCustomString2Label = tostring(cs2Label) , DeviceCustomString2 = tostring(cs2) ,\nDeviceCustomString3Label = tostring(cs3Label) , DeviceCustomString3 = tostring(cs3) ,\nDeviceCustomString4Label = tostring(cs4Label) , DeviceCustomString4 = tostring(cs4) ,\nDeviceCustomString5Label = tostring(cs5Label) , DeviceCustomString5 = tostring(cs5) ,\nDeviceCustomString6Label = tostring(cs6Label) , DeviceCustomString6 = tostring(cs6) ,\nDeviceCustomNumber1Label = tostring(cn1Label) , DeviceCustomNumber1 = toint(cn1) ,\nFlexString1Label = tostring(flexString1Label) , FlexString1 = tostring(flexString1) ,\nFlexString2Label = tostring(flexString2Label) , FlexString2 = tostring(flexString2) ,\nRequestContext = tostring(requestContext),\nDeviceAction = tostring(act) ,\nApplicationProtocol = tostring(app) ,\nDestinationHostName = tostring(dhost) ,\nDestinationIP = tostring(dst) ,\nSourceIP = tostring(src) ,\nRequestURL = tostring(request),\nSentBytes = tolong(out),\nReceivedBytes = tolong(in_bytes),\nRequestClientApplication = tostring(requestClientApplication),\nRequestMethod = tostring(requestMethod),\nSourceUserName = tostring(suser),\nSourceUserPrivileges = tostring(spriv),\nExternalID = toint(externalId),\nExtID = tostring(externalId),\nFileType = tostring(fileType),\nDestinationServiceName = tostring(destinationServiceName),\nCommunicationDirection = tostring(deviceDirection),\nrulelabel = tostring(rulelabel) ,\nruletype = tostring(ruletype),\nurlclass = tostring(urlclass),\ndevicemodel = tostring(devicemodel),\nDeviceVendor = tostring(DeviceVendor),\nDeviceProduct = tostring(DeviceProduct),\nDeviceEventClassID=tostring(act),\nEventOutcome = tostring(outcome) ,\nReason = tostring(reason) ,\nActivity = tostring(reason),\nSourceTranslatedAddress = tostring(sourceTranslatedAddress)\n'
        outputStream: 'Microsoft-CommonSecurityLog'
      }
    ]
  }
  location: location
  name: dcrName
}
