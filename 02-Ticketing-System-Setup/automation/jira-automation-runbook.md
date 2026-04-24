# Jira Automation Runbook

## Script Location
02-Ticketing-System-Setup/automation/jira-ticket-automation.ps1

## Launch Command
powershell -ExecutionPolicy Bypass -File .\jira-ticket-automation.ps1

## Workflow

### 1 Open Script
Launch script in PowerShell.

### 2 Select Ticket Scenario
Current options:
1 New User Provisioning
2 Access Remediation
3 Password Reset

### 3 Enter Ticket Data
Provide:
- Ticket ID
- Requester
- User details
- Scenario specific inputs
- Notes/comments if applicable

### 4 Select Disposition
Available outcomes:
- In Progress
- Waiting for User
- Resolved
- Escalated

### 5 Review Generated Output
Validate:
- Suggested response
- Action summary
- Ticket disposition
- Log output

## Escalation Conditions
Escalate when:
- Approval required
- Security exception exists
- Access conflict exists
- Administrative rights required
- Issue exceeds help desk scope

## Logging
Review:
jira-automation-log.csv

Validate:
- Ticket IDs
- Actions taken
- Disposition
- Notes