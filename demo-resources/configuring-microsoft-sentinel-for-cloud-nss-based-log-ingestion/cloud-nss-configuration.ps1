### This script automates the concatenation of strings to assist with data entry in the Cloud NSS configuration screen ###

$DcrImmutableID = "xxx" ### Found in Monitor -> Data Collection Rules -> Your DCR -> Overview -> JSON View -> API version 2021-09-01-preview -> properties -> immutableId
$DceEndpoint = "xxx" ### Found in Monitor -> Data Collection Endpoints -> Your DCE -> Overview -> Logs Ingestion.
$TableName = "xxx" ### i.e. The name you have give the table, i.e. "Custom-table_1_web_CL"
$ClientID = "xxx" ### Found in Entra ID -> App Registration -> Your App Registration -> Overview -> Application (client) ID
$TenantID = "xxx" ### Found in Entra ID -> App Registration -> Your App Registration -> Overview -> ce16871c-d67d-4678-a9ec-d8907d67794a
$ClientSecret = "xxx" ### Found in Entra ID -> App Registration -> Your App Registration -> Certificates and Secrets -> Use Secret VALUE (not Secret ID)

Write-Output("`n")
Write-Output("Client Id : " + $ClientID)
Write-Output("Client Secret : " + $ClientSecret)

$Scope = "https://monitor.azure.com//.default"
Write-Output("Scope : " + $Scope)
Write-Output("Grant Type : client_credentials")

$AuthorizationURL = "https://login.microsoftonline.com/" + $TenantID + "/oauth2/v2.0/token"
Write-Output("Authorization URL : " + $AuthorizationURL)

$ApiUrl = $DceEndpoint + "/dataCollectionRules/" + $DcrImmutableID + "/streams/" + $TableName + "?api-version=2021-11-01-preview"
Write-Output("API URL : " + $ApiURL)

Write-Output("Key 1 : " + "Content-Type")
Write-Output("Value 1 : " + "application/json")

Write-Output("Feed output type : JSON")
Write-Output('Feed Escape Character : "\,')
Write-Output("`n")