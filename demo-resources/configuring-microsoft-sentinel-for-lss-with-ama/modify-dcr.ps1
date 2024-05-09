### Fill in your instance details for $SubscriptionId, $DcrName and $ResourceGroupName ##
$SubscriptionId = "xxx"
$DcrName = "xxx"
$ResourceGroupName = "xxx" 

$FilePath = "zpa-ama-dcr.json"
$ResourceId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Insights/dataCollectionRules/$DcrName"

### Download DCR ###
$DCR = Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2021-09-01-preview") -Method GET
$DCR.Content | ConvertFrom-Json | ConvertTo-Json -Depth 20 | Out-File -FilePath $FilePath

$DCRContent = Get-Content $FilePath -Raw

# Define the new properties to insert
#$newProperties = ', "transformKql": "source | where SyslogMessage contains \"PrivateSE\" or SyslogMessage contains \"MicroTenantID\" or SyslogMessage contains \"ConnectionID\" or SyslogMessage contains \"requestID\" | extend Message=SyslogMessage", "outputStream": "Custom-ZPA_CL"'

# Adjust the pattern to include lookahead for proper placement after the destinations array
#$pattern = '(?<=("destinations": \[[^\]]*\]))'

# Use the -replace operator to correctly add the new properties after the destinations array
#$DCRContent = $DCRContent -replace $pattern, "$newProperties"


#$DCRContent | Set-Content -Path $FilePath

### Upload DCR
#$UpdatedDCRContent = Get-Content $FilePath -Raw
#Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2021-09-01-preview") -Method PUT -Payload $UpdatedDCRContent
