## Infrastructure Troubleshooting Record

Issue:
HELPDESK01 unable to communicate with domain controller.

Error:
The server is not operational.

Root Cause:
Incorrect DNS on NAT adapter.

Resolution:
Updated adapter DNS to:
192.168.56.10

Outcome:
Domain services connectivity restored.