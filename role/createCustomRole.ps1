# Create custom role “Cloud Onboarding Automation (Level 0)”

# Create custom role for Cloud Onboarding Automation. Level 0 means highest permission level in the Cloud Automation context.
$displayName = "Cloud Onboarding Automation (Level 0)"
$description = "Can manage Application Consents of application registrations."
$templateId = (New-Guid).Guid

# Set of permissions to grant
$allowedResourceAction =
@(
    "microsoft.directory/applications/basic/update", 
    "microsoft.directory/servicePrincipals/allProperties/read",    
    "microsoft.directory/servicePrincipals/managePermissionGrantsForSelf.cloud-onboarding-automation",
    "microsoft.directory/servicePrincipals/managePermissionGrantsForAll.cloud-onboarding-automation"
)
$rolePermissions = @{'allowedResourceActions'= $allowedResourceAction}

# Create the custom role
$customAdmin = New-AzureADMSRoleDefinition -RolePermissions $rolePermissions -DisplayName $displayName -Description $description -TemplateId $templateId -IsEnabled $true
