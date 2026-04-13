Step 07 - Workstation Setup

In this step, I configured a client machine (WORKSTATION01) to communicate with the domain controller (DC01) within a controlled internal network environment using a host-only adapter in VirtualBox.

The workstation was renamed to follow a consistent enterprise naming convention, improving identification and management within the network.

A static IPv4 address (192.168.56.20/24) was assigned to ensure reliable communication and eliminate dependency on DHCP. This guarantees that the workstation maintains a consistent identity within the network.

The DNS server was manually configured to point directly to the domain controller (192.168.56.10). This is a critical configuration because Active Directory relies entirely on DNS for locating domain services, authentication, and resource access. Without proper DNS configuration, domain join operations and user authentication would fail.

Connectivity between WORKSTATION01 and DC01 was verified using ICMP (ping). Successful replies confirmed that the workstation could reach the domain controller and that network communication was functioning as expected.

No default gateway was configured, as this lab environment operates on an isolated host-only network with no requirement for external internet access. This mirrors certain enterprise scenarios where internal systems are segmented from external networks for security purposes.

At the conclusion of this step, WORKSTATION01 is fully prepared for domain integration, with proper IP configuration, DNS alignment, and verified network communication.