using 'cloud-nss-casbemail.bicep'

// Define the 'param' values below

// Found under Log Analytics workspace -> your workspace -> Overview -> Resource group
param resourceGroup = 'your resource group'

// The name of your Log Analytics workspace
param workspaceName = 'your log analytics workspace'

// Found under Log Analytics workspace -> your workspace -> Overview -> JSON View -> "location": (i.e. useast)
param location = 'your location'

// Found under Log Analytics workspace -> your workspace -> Overview -> Subscription ID
param subscriptionId = 'your subscription id'

// Found under Log Analytics workspace -> your workspace -> Overview -> Workspace ID
param workspaceId = 'your workspace id'

// The name you want to provide the Data Collection Endpoint that the template will create
param dceName = 'dce-sentinel-cloud-casbemail'

// The name you want to provide the Data Collection Rule that the template will create
param dcrName = 'dcr-sentinel-cloud-casbemail'
