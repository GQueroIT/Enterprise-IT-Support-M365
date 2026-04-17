# Employee Provisioning Log

## Overview

This CSV file records the results of the user provisioning process executed by the PowerShell automation script.

It serves as an audit and troubleshooting tool to track the success or failure of each user creation attempt.

## File Location

automation/employee-provisioning-log.csv

## Purpose

The log provides visibility into:

- Successful user account creation
- Failed provisioning attempts
- Error messages generated during execution

## Log Structure

The CSV file contains the following fields:

- First Name
- Last Name
- Department
- Title
- Group
- Status (Success / Error)
- Notes (error details or confirmation)

## Troubleshooting Use Case

During initial script execution, the log revealed repeated errors:

Cannot validate argument on parameter 'Path'. The argument is null or empty.

This indicated that the Organizational Unit (OU) path used in the script was not being passed correctly.

## Resolution

The issue was resolved by correcting the OU path in the script:

OU=Sales,DC=corp,DC=smartech,DC=com

After updating the script and rerunning it, all users were successfully provisioned.

## Outcome

- All provisioning errors resolved
- Log confirmed successful creation of all users
- Demonstrates real-world troubleshooting and validation workflow