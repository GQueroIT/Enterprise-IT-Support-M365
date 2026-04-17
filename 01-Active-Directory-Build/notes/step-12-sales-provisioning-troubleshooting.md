# Step 12 - Sales Provisioning Troubleshooting

## Issue

The initial execution of the Sales user provisioning script completed, but no new users appeared in Active Directory.

## Symptoms

- Script displayed a completion message
- Validation queries returned no new Sales users
- The provisioning log showed repeated errors for each attempted account creation

## Root Cause

The provisioning script failed during user creation because the `-Path` value used by `New-ADUser` was not being passed correctly during execution.

The error recorded in the CSV log was:

`Cannot validate argument on parameter 'Path'. The argument is null or empty.`

## Resolution

I verified the correct Distinguished Name for the Sales OU in Active Directory and updated the script to use the full OU path directly.

Correct OU path used:

`OU=Sales,DC=corp,DC=smartech,DC=com`

After updating the script and rerunning it, all 17 Sales users were created successfully and added to the `Sales_Team` group.

## Outcome

This troubleshooting process reinforced the importance of validating OU paths directly in Active Directory when automating account provisioning with PowerShell.