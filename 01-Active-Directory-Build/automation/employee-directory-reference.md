# Employee Directory Reference

## Purpose

This file documents the employee dataset used for automated account provisioning in the Active Directory environment for the Enterprise Help Desk & Microsoft 365 Simulation project.

The accounts in this dataset represent internal employees added to support a more realistic enterprise structure within the lab. These users are used for identity administration, access control, Group Policy targeting, file share permissions, and future help desk ticket scenarios.

---

## Provisioning Scope

This provisioning set includes:

- 17 employee accounts
- Department: Sales
- Target OU: Sales
- Security Group: Sales_Team

All employees created through the provisioning script are intended to simulate production-style user onboarding within a controlled lab environment.

---

## Account Standards

Domain:
corp.smartech.com

Default Password:
Password123!

Password Configuration:
- Password does not expire
- User is not required to change password at next logon

---

## Naming Convention

Format:
first.last

Example:
maria.santos

---

## Directory Placement

OU:
OU=Sales,DC=corp,DC=smartech,DC=com

Security Group:
Sales_Team

---

## Included Attributes

- Given Name
- Surname
- Display Name
- User Principal Name
- SamAccountName
- Department
- Title
- Company
- Office

---

## Notes

All employee records in this lab are simulated for educational and portfolio purposes.