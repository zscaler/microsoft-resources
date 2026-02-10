using 'cloud-nss-sandbox.bicep'

// Define the 'param' values below

// Found under Log Analytics workspace -> your workspace -> Overview -> Resource group
param resourceGroup = 'x'

// The name of your Log Analytics workspace
param workspaceName = 'lx'

// Found under Log Analytics workspace -> your workspace -> Overview -> JSON View -> "location": (i.e. useast)
param location = 'x'

// Found under Log Analytics workspace -> your workspace -> Overview -> Subscription ID
param subscriptionId = 'x'

// Found under Log Analytics workspace -> your workspace -> Overview -> Workspace ID
param workspaceId = 'x'

// The name you want to provide the Data Collection Endpoint that the template will create
param dceName = 'dce-sentinel-cloud-sandbox'

// The name you want to provide the Data Collection Rule that the template will create
param dcrName = 'dcr-sentinel-cloud-sandbox'
