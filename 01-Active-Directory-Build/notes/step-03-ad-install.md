## Step 03 — Install Active Directory Domain Services (AD DS)

Installed the Active Directory Domain Services role using PowerShell to prepare the server for domain controller promotion.

Command used:

- Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Installation included:

- Active Directory Domain Services (AD DS)
- DNS Server role
- Management tools (ADUC, DNS Manager)

Verified installation:

- Confirmed AD-Domain-Services feature shows as Installed

## Key Takeaways

- AD DS installation is required before promoting a server to a domain controller
- DNS is automatically installed because Active Directory relies heavily on DNS for functionality
- PowerShell provides a faster and more controlled method of installing server roles compared to GUI

## Real-World Relevance

In enterprise environments, PowerShell is commonly used to deploy server roles for consistency and automation. Installing AD DS and DNS together ensures that the server is prepared to handle domain authentication, service discovery, and directory services.