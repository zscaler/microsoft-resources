using 'cloud-nss-cloudbranch-session.bicep'

// Define the 'param' values below

// Found under Log Analytics workspace -> your workspace -> Overview -> Resource group
param resourceGroup = ''

// The name of your Log Analytics workspace
param workspaceName = ''

// Found under Log Analytics workspace -> your workspace -> Overview -> JSON View -> "location": (i.e. useast)
param location = ''

// Found under Log Analytics workspace -> your workspace -> Overview -> Subscription ID
param subscriptionId = ''

// Found under Log Analytics workspace -> your workspace -> Overview -> Workspace ID
param workspaceId = ''

// The name you want to provide the Data Collection Endpoint that the template will create
param dceName = 'dce-sentinel-cloud-cloudbranch-session'

// The name you want to provide the Data Collection Rule that the template will create
param dcrName = 'dcr-sentinel-cloud-cloudbranch-session'
