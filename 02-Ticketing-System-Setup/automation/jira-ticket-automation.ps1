Import-Module ActiveDirectory

# =========================================================
# Jira Ticket Automation Script
# Lab Runtime Location: DC01
# Path: C:\LabScripts\jira-ticket-automation.ps1
# =========================================================

# -----------------------------
# Configuration
# -----------------------------
$DefaultPasswordPlain = "Password123!"
$DefaultPassword = ConvertTo-SecureString $DefaultPasswordPlain -AsPlainText -Force

# VM-LOCAL LOG PATH
$LogPath = "C:\LabScripts\Logs\jira-automation-log.csv"

# Department Mapping
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

# -----------------------------
# Ensure folders and log exist
# -----------------------------
if (-not (Test-Path "C:\LabScripts")) {
    New-Item -ItemType Directory -Path "C:\LabScripts" -Force | Out-Null
}

if (-not (Test-Path "C:\LabScripts\Logs")) {
    New-Item -ItemType Directory -Path "C:\LabScripts\Logs" -Force | Out-Null
}

if (-not (Test-Path $LogPath)) {

@'
TicketKey,Scenario,Requester,AffectedUser,Department,Priority,ActionTaken,OU,Group,Status,Technician,DateTime,Notes
'@ | Set-Content $LogPath

}

# -----------------------------
# Helper Functions
# -----------------------------

function Write-Section {
param([string]$Title)

Write-Host ""
Write-Host "==== $Title ====" -ForegroundColor Cyan
}

function Get-NonEmptyInput {
param([string]$Prompt)

do{
    $Value=Read-Host $Prompt
} until(-not [string]::IsNullOrWhiteSpace($Value))

return $Value.Trim()
}

function Get-TicketDisposition {

Write-Host ""
Write-Host "Select Ticket Disposition"
Write-Host "1. Leave Open"
Write-Host "2. In Progress"
Write-Host "3. Waiting For User"
Write-Host "4. Resolved"
Write-Host "5. Escalate"

do{
$Choice=Read-Host "Enter Selection"
} until ($Choice -in 1,2,3,4,5)

switch($Choice){
1 {"Leave Open"}
2 {"In Progress"}
3 {"Waiting For User"}
4 {"Resolved"}
5 {"Escalate"}
}

}

function Get-AdditionalNotes {

$Notes=@()

$Internal=Read-Host "Add internal technician note? (Y/N)"
if($Internal -match '^(Y|y)$'){
$InternalNote=Read-Host "Enter note"
$Notes += "Internal:$InternalNote"
}

$Customer=Read-Host "Add customer note? (Y/N)"
if($Customer -match '^(Y|y)$'){
$CustomerNote=Read-Host "Enter customer-facing note"
$Notes += "Customer:$CustomerNote"
}

return ($Notes -join " | ")
}

function Add-LogEntry {

param(
$TicketKey,
$Scenario,
$Requester,
$AffectedUser,
$Department,
$Priority,
$ActionTaken,
$OU,
$Group,
$Status,
$Technician,
$Notes
)

[PSCustomObject]@{
TicketKey=$TicketKey
Scenario=$Scenario
Requester=$Requester
AffectedUser=$AffectedUser
Department=$Department
Priority=$Priority
ActionTaken=$ActionTaken
OU=$OU
Group=$Group
Status=$Status
Technician=$Technician
DateTime=(Get-Date)
Notes=$Notes
} | Export-Csv -Path $LogPath -Append -NoTypeInformation

}

function Show-Response {

param(
$Type,
$TicketKey,
$ActionTaken
)

Write-Host ""
Write-Host "==== Suggested Jira Response ====" -ForegroundColor Yellow

switch($Type){

"Created" {

Write-Host @"
Request completed successfully.

Action:
$ActionTaken

Ticket:
$TicketKey
"@

}

"Skipped" {

Write-Host @"
No changes were needed.

Ticket:
$TicketKey
"@

}

"ResolvedAccess" {

Write-Host @"
Access issue resolved.

Required permissions were applied.

Ticket:
$TicketKey
"@

}

"PasswordReset" {

Write-Host @"
Password reset completed.

Ticket:
$TicketKey
"@

}

"Escalated" {

Write-Host @"
Request requires escalation.

Ticket:
$TicketKey
"@

}

"Error" {

Write-Host @"
Automation encountered an error.

Ticket:
$TicketKey
"@

}

}

}

function Show-Summary {

param(
$TicketKey,
$Scenario,
$AffectedUser,
$ActionTaken,
$Status,
$Disposition
)

Write-Host ""
Write-Host "==== SUMMARY ====" -ForegroundColor Green
Write-Host "Ticket: $TicketKey"
Write-Host "Scenario: $Scenario"
Write-Host "User: $AffectedUser"
Write-Host "Action: $ActionTaken"
Write-Host "Status: $Status"
Write-Host "Disposition: $Disposition"

}

# =========================================================
# SCENARIO 1
# NEW USER PROVISIONING
# =========================================================

function Invoke-NewUserProvisioning {

Write-Section "New User Provisioning"

$TicketKey=Get-NonEmptyInput "Jira Ticket"
$Requester=Get-NonEmptyInput "Requester"
$FirstName=Get-NonEmptyInput "First Name"
$LastName=Get-NonEmptyInput "Last Name"

$DisplayName="$FirstName $LastName"
$Username="$($FirstName.ToLower()).$($LastName.ToLower())"
$UPN="$Username@corp.smartech.com"

$Department=Get-NonEmptyInput "Department (Sales HR IT)"
$Title=Get-NonEmptyInput "Title"
$Priority=Get-NonEmptyInput "Priority"
$Technician=Get-NonEmptyInput "Technician"

$Scenario="New User Provisioning"
$ActionTaken="Create AD user and assign group"

try{

if(-not $DepartmentMap.ContainsKey($Department)){
throw "Invalid department."
}

$OU=$DepartmentMap[$Department].OU
$Group=$DepartmentMap[$Department].Group

$UserCheck=Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue

if($UserCheck){

$Status="Skipped"
$Notes="User already exists"

}
else{

New-ADUser `
-Name $DisplayName `
-GivenName $FirstName `
-Surname $LastName `
-SamAccountName $Username `
-UserPrincipalName $UPN `
-Department $Department `
-Title $Title `
-Path $OU `
-Enabled $true `
-PasswordNeverExpires $true `
-AccountPassword $DefaultPassword

Add-ADGroupMember $Group $Username

$Status="Created"
$Notes="User created successfully"

}

}
catch{

$Status="Error"
$Notes=$_.Exception.Message

}

$Extra=Get-AdditionalNotes
if($Extra){
$Notes="$Notes | $Extra"
}

$Disposition=Get-TicketDisposition

Add-LogEntry `
$TicketKey `
$Scenario `
$Requester `
$Username `
$Department `
$Priority `
$ActionTaken `
$OU `
$Group `
$Status `
$Technician `
$Notes

Show-Response $Status $TicketKey $ActionTaken

Show-Summary `
$TicketKey `
$Scenario `
$Username `
$ActionTaken `
$Status `
$Disposition

}

# =========================================================
# SCENARIO 2
# ACCESS REMEDIATION
# =========================================================

function Invoke-AccessRemediation {

Write-Section "Access Remediation"

$TicketKey=Get-NonEmptyInput "Jira Ticket"
$Requester=Get-NonEmptyInput "Requester"
$AffectedUser=Get-NonEmptyInput "Username"
$Department=Get-NonEmptyInput "Department"
$Group=Get-NonEmptyInput "Access Group"
$Approval=Get-NonEmptyInput "Approval Confirmed Y/N"
$Priority=Get-NonEmptyInput "Priority"
$Technician=Get-NonEmptyInput "Technician"

$Scenario="Access Remediation"
$ActionTaken="Validate and restore access"

try{

if($Approval -notmatch '^(Y|y)$'){
$Status="Escalated"
$Notes="Approval not confirmed"
}
else{

$Member=Get-ADGroupMember $Group | Where-Object {$_.SamAccountName -eq $AffectedUser}

if($Member){
$Status="Skipped"
$Notes="Access already present"
}
else{
Add-ADGroupMember $Group $AffectedUser
$Status="Remediated"
$Notes="Access restored"
}

}

}
catch{
$Status="Error"
$Notes=$_.Exception.Message
}

$Extra=Get-AdditionalNotes
if($Extra){
$Notes="$Notes | $Extra"
}

$Disposition=Get-TicketDisposition

Add-LogEntry `
$TicketKey `
$Scenario `
$Requester `
$AffectedUser `
$Department `
$Priority `
$ActionTaken `
"" `
$Group `
$Status `
$Technician `
$Notes

if($Status -eq "Remediated"){
Show-Response "ResolvedAccess" $TicketKey $ActionTaken
}
else{
Show-Response $Status $TicketKey $ActionTaken
}

Show-Summary `
$TicketKey `
$Scenario `
$AffectedUser `
$ActionTaken `
$Status `
$Disposition

}

# =========================================================
# SCENARIO 3
# PASSWORD RESET
# =========================================================

function Invoke-PasswordReset {

Write-Section "Password Reset"

$TicketKey=Get-NonEmptyInput "Jira Ticket"
$Requester=Get-NonEmptyInput "Requester"
$AffectedUser=Get-NonEmptyInput "Username"
$Verify=Get-NonEmptyInput "Identity Verified Y/N"
$TempPassword=Get-NonEmptyInput "Temporary Password"
$Priority=Get-NonEmptyInput "Priority"
$Department=Get-NonEmptyInput "Department"
$Technician=Get-NonEmptyInput "Technician"

$Scenario="Password Reset"
$ActionTaken="Reset user password"

try{

if($Verify -notmatch '^(Y|y)$'){
$Status="Escalated"
$Notes="Identity not verified"
}
else{

$SecurePassword=ConvertTo-SecureString $TempPassword -AsPlainText -Force

Set-ADAccountPassword `
-Identity $AffectedUser `
-NewPassword $SecurePassword `
-Reset

Set-ADUser `
-Identity $AffectedUser `
-ChangePasswordAtLogon $true

$Status="Reset Completed"
$Notes="Password reset complete"

}

}
catch{

$Status="Error"
$Notes=$_.Exception.Message

}

$Extra=Get-AdditionalNotes
if($Extra){
$Notes="$Notes | $Extra"
}

$Disposition=Get-TicketDisposition

Add-LogEntry `
$TicketKey `
$Scenario `
$Requester `
$AffectedUser `
$Department `
$Priority `
$ActionTaken `
"" `
"" `
$Status `
$Technician `
$Notes

if($Status -eq "Reset Completed"){
Show-Response "PasswordReset" $TicketKey $ActionTaken
}
else{
Show-Response $Status $TicketKey $ActionTaken
}

Show-Summary `
$TicketKey `
$Scenario `
$AffectedUser `
$ActionTaken `
$Status `
$Disposition

}

# =========================================================
# MAIN MENU
# =========================================================

do{

Write-Section "Jira Ticket Automation"

Write-Host "1 New User Provisioning"
Write-Host "2 Access Remediation"
Write-Host "3 Password Reset"
Write-Host "4 Exit"

$Choice=Read-Host "Select"

switch($Choice){

1 {Invoke-NewUserProvisioning}
2 {Invoke-AccessRemediation}
3 {Invoke-PasswordReset}
4 {Write-Host "Exiting..."}

default{
Write-Host "Invalid Selection"
}

}

}
until($Choice -eq 4)