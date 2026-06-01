using 'cloud-nss-zpa-appprotection.bicep'

// Found under Log Analytics workspace -> your workspace -> Overview -> Resource group
param resourceGroup = 'x'

// The name of your Log Analytics workspace
param workspaceName = 'x'

// Found under Log Analytics workspace -> your workspace -> Overview -> JSON View -> "location"
param location = 'x'

// Found under Log Analytics workspace -> your workspace -> Overview -> Subscription ID
param subscriptionId = 'x'

// Found under Log Analytics workspace -> your workspace -> Overview -> Workspace ID
param workspaceId = 'x'

// The name to give the Data Collection Endpoint the template will create
param dceName = 'dce-zpa-appprotection-cloudnss'

// The name to give the Data Collection Rule the template will create
param dcrName = 'dcr-zpa-appprotection-cloudnss'
