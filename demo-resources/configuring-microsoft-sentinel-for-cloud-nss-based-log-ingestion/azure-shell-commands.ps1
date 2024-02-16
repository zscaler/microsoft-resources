### Fill in your instance details for $SubscriptionId, $DcrName and $ResourceGroupName ##

$SubscriptionId = "xxx"
$DcrName = "xxx"
$ResourceGroupName = "xxx"

$FilePath = "tmp.json"
$ResourceId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Insights/dataCollectionRules/$DcrName"

### Download DCR ###
$DCR = Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2021-09-01-preview") -Method GET
$DCR.Content | ConvertFrom-Json | ConvertTo-Json -Depth 20 | Out-File -FilePath $FilePath

# Replace the outputStream value with "outputStream": "Microsoft-CommonSecurityLog"
$DCRContent = Get-Content $FilePath -Raw
$DCRContent = $DCRContent -replace '"outputStream": "[^"]*"', '"outputStream": "Microsoft-CommonSecurityLog"'
$DCRContent | Set-Content -Path $FilePath

### Upload DCR
$UpdatedDCRContent = Get-Content $FilePath -Raw
Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2021-09-01-preview") -Method PUT -Payload $UpdatedDCRContent