using 'cloud-nss-admin-audit.bicep'

// Define the 'param' values below

// Found under Log Analytics workspace -> your workspace -> Overview -> Resource group
param resourceGroup = 'xxx'

// The name of your Log Analytics workspace
param workspaceName = 'xxx'

// Found under Log Analytics workspace -> your workspace -> Overview -> JSON View -> "location": (i.e. useast)
param location = 'xxx'

// Found under Log Analytics workspace -> your workspace -> Overview -> Subscription ID
param subscriptionId = 'xxx'

// Found under Log Analytics workspace -> your workspace -> Overview -> Workspace ID
param workspaceId = 'xxx'

// The name you want to provide the Data Collection Endpoint that the template will create
param dceName = 'xxx'

// The name you want to provide the Data Collection Rule that the template will create
param dcrName = 'xxx'
