Step 08 - Domain Join

In this step, I joined WORKSTATION01 to the domain corp.smartech.com.

Before attempting the domain join, I verified that the workstation had a static IPv4 address configured and that the DNS server was pointing to the domain controller (DC01). This is a critical requirement because Active Directory relies on DNS for locating domain services and handling authentication.

Initial connectivity testing between WORKSTATION01 and DC01 revealed that ICMP (ping) requests were not successful due to Windows Firewall restrictions. To properly validate communication, I enabled the appropriate inbound firewall rule to allow ICMP echo requests. Once applied, successful replies confirmed that network communication between the systems was functioning as expected.

During the domain join process, I encountered an issue caused by a duplicate machine SID, which resulted from cloning the workstation without generalizing the system. This prevented the machine from joining the domain.

To resolve this, I used the System Preparation Tool (Sysprep) with the "Generalize" option enabled. This reset the system’s unique identifier and prepared it as a new machine. After reconfiguring the hostname, IP address, and DNS settings, I successfully joined WORKSTATION01 to the domain.

At the conclusion of this step, WORKSTATION01 is fully integrated into the Active Directory environment, with proper DNS configuration, verified network communication, and readiness for domain-based authentication.