# Employee User Provisioning Script

## Overview

This PowerShell script automates the creation of Active Directory user accounts for the Sales department within the lab environment.

The script provisions multiple users in bulk, assigns them to the correct Organizational Unit (OU), applies standard attributes, and adds them to the appropriate security group.

## Purpose

The goal of this script is to simulate real-world onboarding workflows in an enterprise environment, where IT administrators must efficiently create and configure multiple user accounts.

## Key Features

- Bulk user creation using predefined dataset
- Automatic placement into the Sales OU
- Assignment to the Sales_Team security group
- Standardized attribute configuration:
  - First Name
  - Last Name
  - Display Name
  - User Principal Name (UPN)
  - Department
  - Title
  - Company
  - Office
- Default password applied for lab consistency
- Password set to non-expiring (lab scenario)
- CSV logging of provisioning results

## Script Location

automation/employee-user-provisioning.ps1

## Execution Command

powershell -ExecutionPolicy Bypass -File "C:\LabScripts\employee-user-provisioning.ps1"

## Validation

Get-ADUser -SearchBase "OU=Sales,DC=corp,DC=smartech,DC=com" -Filter * |
Select Name, SamAccountName | Sort Name

## Outcome

- 17 Sales users successfully created
- All users added to Sales_Team
- Directory structure expanded to support realistic help desk scenarios