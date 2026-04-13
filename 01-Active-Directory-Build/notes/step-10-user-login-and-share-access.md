Step 10 - User Login and Shared Drive Access Validation

In this step, I validated that a domain user could successfully sign in to WORKSTATION01 and access the mapped HR shared drive.

After signing in with an HR user account, I confirmed that the Group Policy drive mapping was applied and that the HR Shared Drive (Z:) appeared automatically in File Explorer.

I then opened the mapped drive and created a test file to confirm that both the drive mapping and underlying permissions were functioning correctly. This verified that authentication, Group Policy processing, drive mapping, share permissions, and NTFS permissions were all working together as intended.

To further confirm access, I verified from DC01 that the test file appeared inside the shared folder on the server.

This step establishes a working baseline for future help desk scenarios involving login issues, missing drive mappings, or access-related problems.