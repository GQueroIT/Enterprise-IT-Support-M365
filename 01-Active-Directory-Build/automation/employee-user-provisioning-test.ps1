Import-Module ActiveDirectory

# =========================================================
# Employee User Provisioning Script - TEST VERSION
# Project: Enterprise Help Desk & Microsoft 365 Simulation
# Phase: 01-Active-Directory-Build
# Purpose:
# Interactive Active Directory user provisioning with
# department-based OU and group mapping plus CSV logging
# =========================================================

$DefaultPasswordPlain = "Password123!"
$DefaultPassword = ConvertTo-SecureString $DefaultPasswordPlain -AsPlainText -Force
$LogPath = "C:\LabScripts\Logs\employee-provisioning-test-log.csv"

# Create log file with headers if it does not exist
if (-not (Test-Path $LogPath)) {
    [PSCustomObject]@{
        FirstName         = "FirstName"
        LastName          = "LastName"
        DisplayName       = "DisplayName"
        Username          = "Username"
        UserPrincipalName = "UserPrincipalName"
        Department        = "Department"
        Title             = "Title"
        OU                = "OU"
        Group             = "Group"
        Status            = "Status"
        Notes             = "Notes"
    } | Export-Csv -Path $LogPath -NoTypeInformation
}

# Department mapping
$DepartmentMap = @{
    "Sales" = @{
        OU    = "OU=Sales,DC=corp,DC=smartech,DC=com"
        Group = "Sales_Team"
    }
    "HR" = @{
        OU    = "OU=HR,DC=corp,DC=smartech,DC=com"
        Group = "HR_Team"
    }
    "IT" = @{
        OU    = "OU=IT,DC=corp,DC=smartech,DC=com"
        Group = "IT_Admins"
    }
}

do {
    Write-Host ""
    Write-Host "==== New Employee Provisioning ====" -ForegroundColor Cyan

    $FirstName = Read-Host "Enter first name"
    $LastName = Read-Host "Enter last name"

    $DefaultDisplayName = "$FirstName $LastName"
    $DisplayNameInput = Read-Host "Enter display name [$DefaultDisplayName]"
    if ([string]::IsNullOrWhiteSpace($DisplayNameInput)) {
        $DisplayName = $DefaultDisplayName
    }
    else {
        $DisplayName = $DisplayNameInput
    }

    $DefaultUsername = ($FirstName + "." + $LastName).ToLower()
    $UsernameInput = Read-Host "Enter username [$DefaultUsername]"
    if ([string]::IsNullOrWhiteSpace($UsernameInput)) {
        $Username = $DefaultUsername
    }
    else {
        $Username = $UsernameInput.ToLower()
    }

    $DefaultUPN = "$Username@corp.smartech.com"
    $UPNInput = Read-Host "Enter user principal name [$DefaultUPN]"
    if ([string]::IsNullOrWhiteSpace($UPNInput)) {
        $UserPrincipalName = $DefaultUPN
    }
    else {
        $UserPrincipalName = $UPNInput.ToLower()
    }

    $DepartmentInput = Read-Host "Enter department (Sales, HR, IT)"
    $Department = $DepartmentInput.Trim()

    $Title = Read-Host "Enter title"

    $Status = ""
    $Notes = ""
    $OU = ""
    $Group = ""

    try {
        if (-not $DepartmentMap.ContainsKey($Department)) {
            throw "Invalid department. Valid options are: Sales, HR, IT."
        }

        $OU = $DepartmentMap[$Department].OU
        $Group = $DepartmentMap[$Department].Group

        # Validate OU exists
        $null = Get-ADOrganizationalUnit -Identity $OU -ErrorAction Stop

        # Validate group exists
        $null = Get-ADGroup -Identity $Group -ErrorAction Stop

        # Check if user already exists
        $ExistingUser = Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue

        if ($null -ne $ExistingUser) {
            $Status = "Skipped"
            $Notes = "User already exists"
            Write-Host "Skipped: $DisplayName already exists." -ForegroundColor Yellow
        }
        else {
            New-ADUser `
                -Name $DisplayName `
                -GivenName $FirstName `
                -Surname $LastName `
                -DisplayName $DisplayName `
                -SamAccountName $Username `
                -UserPrincipalName $UserPrincipalName `
                -Department $Department `
                -Title $Title `
                -Path $OU `
                -AccountPassword $DefaultPassword `
                -Enabled $true `
                -PasswordNeverExpires $true `
                -ChangePasswordAtLogon $false

            Add-ADGroupMember -Identity $Group -Members $Username

            $Status = "Created"
            $Notes = "User created and added to group successfully"
            Write-Host "Created: $DisplayName" -ForegroundColor Green
            Write-Host "OU: $OU" -ForegroundColor DarkGray
            Write-Host "Group: $Group" -ForegroundColor DarkGray
        }
    }
    catch {
        $Status = "Error"
        $Notes = $_.Exception.Message
        Write-Host "Error: $DisplayName" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }

    [PSCustomObject]@{
        FirstName         = $FirstName
        LastName          = $LastName
        DisplayName       = $DisplayName
        Username          = $Username
        UserPrincipalName = $UserPrincipalName
        Department        = $Department
        Title             = $Title
        OU                = $OU
        Group             = $Group
        Status            = $Status
        Notes             = $Notes
    } | Export-Csv -Path $LogPath -NoTypeInformation -Append

    Write-Host ""
    $Continue = Read-Host "Do you want to add another employee? (Y/N)"

} while ($Continue -match '^(Y|y)$')

Write-Host ""
Write-Host "Provisioning session complete. Log saved to: $LogPath" -ForegroundColor Cyan