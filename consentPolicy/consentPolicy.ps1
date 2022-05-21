# Create Consent Policy
# Requires P1 license on AAD
#

$tenantId = "your tenant id"

# Connect Azure AD, Login with an identity that has “Global Administrator” permissions
Connect-AzureAd -TenantId $tenantId

# List all current Consent Grant Policies just to get the base understanding of what are they.
# You’ll get the list of MS built-in Grant Policies that are “permanent”. + of course any custom ones, if those exist.
Get-AzureADMSPermissionGrantPolicy | ft Id, DisplayName, Description

$GraphAppId = "00000003-0000-0000-c000-000000000000"

# Get the Role Id for "GroupMember.Read.All
$GroupMemberRoleOid=((Get-AzureADServicePrincipal -ObjectId $GraphOid).AppRoles | ?{ $_.Value -eq "GroupMember.Read.All" }).Id

# Create the Consent Policy
New-AzureADMSPermissionGrantPolicy `
    -Id "cloud-onboarding-automation" `
    -DisplayName "Cloud onboarding automation Policy" `
    -Description "Permissions consentable by Cloud Application Automation"

# Create the permission grant conditions set
# for allowing 'application' type grant for role GroupMember.Read.All in the MS Graph API
New-AzureADMSPermissionGrantConditionSet `
    -PolicyId "cloud-onboarding-automation" `
    -ConditionSetType "includes" `
    -PermissionType "application" `
    -Permissions $GroupMemberRoleOid `
    -ResourceApplication $GraphAppId

# Get the Consent Policy and check “Includes”
$cpolicy = Get-AzureADMSPermissionGrantPolicy -Id "cloud-onboarding-automation"
$cpolicy.Includes
