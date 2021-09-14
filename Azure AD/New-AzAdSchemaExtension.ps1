$extensionId = 'accessGroup'
$extensionDescription = 'Extension to define an access group'
$applicationId = '00107115-94e6-41fa-8337-d5f7ed9c4477'

# Connect to Microsoft Graph with the required scopes
Connect-MgGraph -Scopes "Application.ReadWrite.All","Directory.AccessAsUser.All" -UseDeviceAuthentication

# After authenticating, we create a new, empty ArrayList
$schemaProperties = New-Object -TypeName System.Collections.ArrayList

# define our keys and the types

$property1 = @{
    'name' = 'groupName';
    'type' = 'String';
}

# and add them to the SchemaProperties
[void]$SchemaProperties.Add($property1)

# Now we can create the new schema extension for the resource User. Our Azure AD app is the owner.
New-MgSchemaExtension -TargetTypes @('Group') `
    -Properties $schemaProperties `
    -Id $extensionId `
    -Description $extensionDescription `
    -Owner $applicationId

# Check the new schema extension:
Get-MgSchemaExtension -SchemaExtensionId 'extflrk3jsn_accessGroup' | fl

Update-MgSchemaExtension -SchemaExtensionId 'ext4h6rkdob_accessGroup' -Status 'Available' -Owner $applicationId


ext4h6rkdob_accessGroup