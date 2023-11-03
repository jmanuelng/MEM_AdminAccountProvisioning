<#
.SYNOPSIS
Verifies the existence of a local user account and its membership in the Administrators group.

.DESCRIPTION
Looks for a specified local user account on a Windows device and verifies whether the account is a member of the local Administrators group. If PowerShell cmdlets fail, it falls back to using 'net localgroup'.

.INSTRUCTIONS
To use this script, you must manually set the following variable within the script code:
- $UserName: The username for the local user account you wish to verify.

For example:
$UserName = 'adminuser'

.EXAMPLE
.\Detect_AdminAccountSetup.ps1

This example checks if the specified local user account exists and is a member of the Administrators group.

.NOTES
Original Author: Nicola Suter
Original Script for User Detection: https://gist.githubusercontent.com/nicolonsky/aecd9f0fa689cebf49b623f209f21f38/raw/0f3362795799cb42e05b892767c0bf46c57f68ac/Detect-CustomAdminAccountExists.ps1

Script requires administrative privileges to run and will fail if executed in a non-elevated PowerShell session.

.LINK
Documentation on Get-LocalUser and Get-LocalGroupMember: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.localaccounts/
#>

# Requires -Version 5.0

# Declare the variable for user detection
$UserName = 'SpecifyUserNameHere' # Specify the username for the local user account to verify.

# Initialize result variables
$result = 0
$detectSummary = ""

# Check if the user exists
try {
    # $user = Get-LocalUser -Name $UserName -ErrorAction Stop
    $detectSummary += "User exists. "
    
    # Verify if the user is part of the Administrators group
    $admins = Get-LocalGroupMember -Group "Administrators" -ErrorAction Stop | Select-Object -ExpandProperty Name
    if ($UserName -in $admins) {
        $detectSummary += "User is in Administrators. "
    } else {
        $detectSummary += "User NOT member of Administrators group. "
        $result = 1
    }
} catch [Microsoft.PowerShell.Commands.UserNotFoundException] {
    $result = 1
    $detectSummary += "User does NOT exist. "
} catch {
    # Fallback to net localgroup command if Get-LocalGroupMember fails
    try {
        $admins = net localgroup Administrators | Where-Object { $_ -match $UserName }
        if ($admins) {
            $detectSummary += "User is in Administrators. "
        } else {
            $detectSummary += "User NOT member of Administrators group. "
            $result = 1
        }
    } catch {
        $result = 2
        $detectSummary += "Error occurred while checking for user with net localgroup. Error: $_ "
    }
}

# Output the result
if ($result -eq 0) {
    Write-Host "OK $([datetime]::Now) : $detectSummary"
    Exit 0
}
elseif ($result -eq 1) {
    Write-Host "FAIL $([datetime]::Now) : $detectSummary"
    Exit 1
}
else {
    Write-Host "NOTE $([datetime]::Now) : $detectSummary"
    Exit 2
}
