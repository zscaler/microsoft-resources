# This script will send a sample log to a Log Analytics workspace via a DCR. If it fails, it will point the admin to where the issue could potentially be, i.e. secret value, dcr immutable id etc.

$tenantId = "xx"; # Found in Entra ID -> App Registrations -> All Applications -> Your App Registration -> Directory (tenant) ID
$appId = "xx"; # Found in Entra ID -> App Registrations -> All Applications -> Your App Registration -> Application (client) ID
$appSecret = "xx"; # Found in Entra ID -> App Registrations -> All Applications -> Your App Registration -> Secrets and Certificates -> Client Secret -> Value
$DcrImmutableId = "dcr-xx" # Found in Monitor -> Settings -> Data Collection Rules -> Your Data Collection Rule -> Overview -> JSON View -> "immutableId" value
$DceURI = "https://dce-xx.ingest.monitor.azure.com" # Found in Monitor -> Settings -> Data Collection Endpoints -> Your Data Collection Endpoint -> Overview -> "Log Ingestion" URL value
$Table = "Custom-nss_xx_CL" # Found in Monitor -> Settings -> Data Collection Rules -> Your Data Collection Rule -> Overview -> JSON View -> The Table Name under "streamDeclarations", i.e.  "Custom-nss_casbcloudstorage_CL"

# Name of the JSON sample log file to test
$log_file = "sample-xx.log"

# Read the JSON file content
$json_string = Get-Content -Path $log_file -Raw

# Convert the JSON string to a PowerShell object
$json_object = $json_string | ConvertFrom-Json

# Update the 'TimeGenerated' property with a new timestamp
$new_timestamp = Get-Date ([datetime]::UtcNow) -Format O

if ($json_object.PSObject.Properties['TimeGenerated']) {
    $json_object.TimeGenerated = $new_timestamp
} elseif ($json_object.PSObject.Properties['datetime']) {
    $json_object.datetime = $new_timestamp
}

$json_object

try {
    ## Obtain a bearer token used to authenticate against the data collection endpoint
    $bearerSuccess = $false
    $scope = [System.Web.HttpUtility]::UrlEncode("https://monitor.azure.com//.default")   
    $body = "client_id=$appId&scope=$scope&client_secret=$appSecret&grant_type=client_credentials"
    $headers = @{"Content-Type" = "application/x-www-form-urlencoded" }
    $uri = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
    $bearerTokenResponse = Invoke-RestMethod -Uri $uri -Method "Post" -Body $body -Headers $headers -ErrorAction Stop
    $bearerToken = $bearerTokenResponse.access_token
    $bearerSuccess = $true

    # Sending the data to Log Analytics via the DCR!
    $body = $json_object | ConvertTo-Json -AsArray
    $headers = @{"Authorization" = "Bearer $bearerToken"; "Content-Type" = "application/json" }
    $uri = "$DceURI/dataCollectionRules/$DcrImmutableId/streams/$Table"+"?api-version=2021-11-01-preview"
    $uploadResponse = Invoke-RestMethod -Uri $uri -Method "Post" -Body $body -Headers $headers -ErrorAction Stop

    # Let's see how the response looks
    Write-Output "--------------"
    Write-Output $uploadResponse
    Write-Output "--------------"
} catch {
    Write-Output $_.Exception.Message
    if ($_.Exception.Message -eq "Response status code does not indicate success: 400 (Bad Request)." -and $bearerSuccess -eq $false) {
        Write-Error "Incorrect appId or tenantId"
    } elseif ($_.Exception.Message -eq "Response status code does not indicate success: 400 (Bad Request)." -and $bearerSuccess -eq $true) {
        Write-Error "Incorrect Table"
    } elseif ($_.Exception.Message -eq "Response status code does not indicate success: 401 (Unauthorized).") {
        Write-Error "Incorrect appSecret or App Registration does not have correct role assignments."
    } elseif ($_.Exception.Message -eq "Response status code does not indicate success: 404 (Not Found).") {
        Write-Error "Incorrect DcrImmutableId"
    } else {
        Write-Error "Incorrect DceURI"
    }
}