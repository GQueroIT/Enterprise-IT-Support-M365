# Step 09 - GPO Drive Mapping

In this step, I created and applied a Group Policy Object (GPO) to centrally map a shared network drive for domain users through Active Directory.

A shared departmental resource (HR-Shared) was created on DC01 and published as a network share. Using Group Policy Preferences, I configured a mapped drive to assign drive letter Z: to \\DC01\HR-Shared for users in the HR organizational unit.

The GPO was linked to the HR OU and tested from WORKSTATION01. After forcing policy updates and validating policy application, the mapped drive appeared successfully for the domain user.

## Validation Performed

- Verified GPO link to correct OU
- Confirmed user membership and policy scope
- Forced policy refresh using:

```powershell
gpupdate /force
gpresult /r
```

- Confirmed mapped drive presence in File Explorer
- Verified access to shared resources through drive Z:

## Troubleshooting Encountered

Initial drive mapping failed even though the GPO was applying successfully.

### Issue Identified
The policy originally referenced a share path that did not exist:

```plaintext
\\DC01\IT_Share
```

Because the UNC path was invalid, Group Policy processed but the mapped drive could not be created.

### Root Cause
- Incorrect share referenced in GPO
- Existing valid shared resource was HR-Shared
- Drive mapping failure was caused by share configuration, not GPO processing

### Resolution
Updated the drive mapping path to:

```plaintext
\\DC01\HR-Shared
```

Reapplied policy, refreshed Group Policy on the workstation, and verified successful drive mapping.

## Evidence Note

Initial implementation screenshots during first GPO deployment were missed during live configuration.

To preserve documentation integrity, post-implementation validation evidence was captured instead, demonstrating:
- Final GPO configuration
- Applied policy results
- Successful mapped drive deployment
- Troubleshooting and remediation performed

This mirrors real-world change validation documentation where post-change evidence is often used to support successful implementation.

## Outcome

This step demonstrates:

- Centralized administration using Group Policy
- Network share deployment through Active Directory
- GPO troubleshooting and validation
- Enterprise-style file access management
- Real-world diagnosis and correction of policy deployment issues