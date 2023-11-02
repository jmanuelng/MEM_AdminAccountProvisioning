<#
.SYNOPSIS
Creates a new local user account and adds it to the Administrators group with a specified password length.

.DESCRIPTION
Script creates a new local user account with a specified username and a randomly generated password of a specified length. 
It then adds the new user to the built-in Administrators group. 
Password is generated to be complex and secure, best practices for password security.

.INSTRUCTIONS
To use script, you must manually set the following variables within the script code:
- $UserName: The username for the new local user account.
- $Description: A description for the new local user account to identify its purpose.
- $PasswordLength: The length of the generated password for the new local user account.

For example:
$UserName = 'clientadmin'
$Description = 'LAPS Client Admin'
$PasswordLength = 20

.EXAMPLE
.\Fix_AdminAccountSetup.ps1

This example creates a new local user account with administrative privileges, a description, and a password with the length specified in the script.

.NOTES
Original Author: Nicola Suter
Original Script: https://gist.githubusercontent.com/nicolonsky/77e34dd81e91a92a3b26073e8c2fab5b/raw/36e407a3602fa4574bbbd073d325740a02275aaf/Remediate-CustomAdminAccountExists.ps1

Script requires administrative privileges to run and will fail if executed in a non-elevated PowerShell session.

.LINK
Documentation on New-LocalUser: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.localaccounts/new-localuser
Documentation on Add-LocalGroupMember: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.localaccounts/add-localgroupmember
#>

# Requires -Version 5.0

# Declare the variables for user creation
$UserName = 'SpecifyUserNameHere' # Specify the username for the new local user account.
$Description = 'SpecifyUserDescriptionHere' # Specify a description for the new local user account.
$PasswordLength = 20 # Specify the length of the generated password for the new local user account.

# Initialize result variables
$result = 0
$detectSummary = ""

# Load the required assembly for password generation
Add-Type -AssemblyName 'System.Web'

# User parameters
$userParams = @{
    Name        = $UserName
    Description = $Description
    Password    = [System.Web.Security.Membership]::GeneratePassword($PasswordLength, 2) | ConvertTo-SecureString -AsPlainText -Force
}

# Create user with random password
try {
    $user = New-LocalUser @userParams -ErrorAction Stop
    $detectSummary += "User `'$($user.Name)' created successfully with a random password. "
} catch {
    $result = 1
    $detectSummary += "Failed to create user. Error: $_ "
}

# Add user to built-in administrators group if user was created successfully
if ($result -eq 0) {
    try {
        Add-LocalGroupMember -SID 'S-1-5-32-544' -Member $user -ErrorAction Stop
        $detectSummary += "User `'$($user.Name)' added to Administrators group. "
    } catch {
        $result = 1
        $detectSummary += "Failed to add user to Administrators group. Error: $_ "
    }
}

# Output the username and indicate completion
if ($result -eq 0) {
    $detectSummary += "User created with $PasswordLength characer password. "
    Write-Host "OK $([datetime]::Now) : $detectSummary"
    Exit 0
}
elseif ($result -eq 1) {
    Write-Host "FAIL $([datetime]::Now) : $detectSummary"
    Exit 1
}
else {
    Write-Host "NOTE $([datetime]::Now) : $detectSummary"
    Exit 0
}
