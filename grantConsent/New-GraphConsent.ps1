# Version 1.0
$runlocally = $false
if ($runlocally) {    
    $env:SYSTEM_DEFAULTWORKINGDIRECTORY = ""
    $env:STATEPATH = ""
    $consentUserName = ""
    $consentSecretVariableName = ""
    $params = @{}
    $params.devops = @{}    
    $params.devops.projectname = ""
    $params.azuread = @{}
    $params.azuread.tenantId = ""
}

# Read project parameters from file
#
# Project Definitions
if (!$runlocally) {    
    $projectDefinition = "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)\$($env:STATEPATH)\newproject.json"
}

try {
    $params = Get-Content -Path $projectDefinition | ConvertFrom-Json
}
catch {
    Write-Host  "##vso[task.LogIssue type=error;]Could not open newProject.json file"
    exit 1
}

# Login to AZ
az login --username $(consentUserName) --password '$(consentSecretVariableName)' --tenant $params.azuread.tenantId --allow-no-subscriptions

# Set up SPN variable.
$spname = "devops-sub-$($params.devops.projectname)-prod-spn"

# Get the SPN
# Retrieve Object for SPN by Name
$result = az ad sp list `
    --filter "displayName eq '$($spName)'" `
    --query '[].{displayName:displayName,objectId:objectId,appId:appId,appOwnerTenantId:appOwnerTenantId}' `
    | convertFrom-Json
if ($? -eq $false) {
    Write-Host  "##vso[task.LogIssue type=error;]Could not retrieve SPN Object. Error : $($?)"
} else {    
    $appId = $result.appId
}    

if ($appid) {
    # Grant Admin Consent to MS Graph API, Permission GroupMember.Read.All
    $result = az ad app permission admin-consent `
        --id $appId `
    | convertFrom-Json
    if ($? -eq $false) {
        Write-Host  "##vso[task.LogIssue type=error;]Could not grant admin consent. Error : $($?)"
    }   
}
else {
    Write-Host  "##vso[task.LogIssue type=error;]No Client Id (Application Id) found. Cannot manage Admin consent. Error : $($?)"
}
