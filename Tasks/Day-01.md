# Day 01 – Linux User Setup with Non-interactive Shell

---

## Task Overview
Create a Linux service user with **no interactive shell access**. This type of user is commonly used for running services or automation tasks and improves system security by preventing direct logins.

---

## Objective  
- Create a service/system user  
- Assign a non-interactive shell  
- Ensure the home directory is created  
- Validate that interactive login is disabled

---

## Step-by-Step Implementation 

### Step 1: Connect to the application server via SSH

```bash
ssh user@app-server-ip
# or
ssh user@server-name
```
#### Explanation:
Connect to the server using SSH. Replace user with your actual username and server-name or app-server-ip with the server details. This lets you securely access the Linux server from your local machine.

### Step 2: Create a user with a non-interactive shell

```bash
sudo useradd -m -s /usr/sbin/nologin user-name
```
#### Explanation:
Creates a new system user account with restricted shell access.

`-m` creates a home directory at /home/user-name.

`-s` /usr/sbin/nologin assigns a non-interactive shell, preventing terminal logins.

This setup is ideal for service accounts, automation users, or application runtime users that should exist on the system but must not have interactive access. Replace user-name with the username required by the task.

### Step 3: Verify user creation in the system database

```bash
cat /etc/passwd
```

#### Explanation:
Displays user account entries stored on the system. Look for the newly created user entry, which should appear like:

```bash
username:x:1003:1004::/home/username:/usr/sbin/nologin
```
This confirms:
- The user exists
- The home directory is set
- The login shell is /usr/sbin/nologin, which disables interactive access

> Tip: You can also use ``getent passwd user-name`` for a cleaner, targeted check.

### Step 4: Test that interactive login is blocked

```bash
sudo su user-name
```
#### Explanation:
Attempts to switch to the newly created user. The command should fail with a message like:

```bash
This account is currently not available.
```
This confirms the non-interactive shell is working as expected and interactive login is blocked.

### Additional Commands 

```bash
# List all users with nologin shell
grep nologin /etc/passwd

# Check user details
id user-name

# Remove the user if needed
sudo userdel -r user-name
```
---

## Key Concepts

### Types of Shells
- `/bin/bash` – Standard interactive shell used by regular users for day-to-day terminal work.  
- `/usr/sbin/nologin` – Non-interactive shell that blocks terminal login and shows a message when someone tries to access the account.  
- `/bin/false` – Immediately exits on any login attempt; another simple way to disable interactive access.  

---

### Security Best Practices  
- Always use non-interactive shells for service accounts, bots, and automation users.  
- Never run applications as `root`; create dedicated service users for each service where possible.  
- Limit permissions for service users to only the files and directories they need.  
- Disable password login for service users if they don’t need to authenticate interactively.  
- This approach reduces the impact of compromised credentials and follows the **principle of least privilege**.

---

### User Management Files  
- `/etc/passwd` – Stores basic user account details such as username, UID, GID, home directory, and shell. This file is readable by all users.  
- `/etc/shadow` – Stores encrypted password hashes and password aging info. Only root can read this file.  
- `/etc/group` – Stores group names and user memberships.
  
---

### User & Permission Basics  
- Every user has a unique **UID** and belongs to a primary group (**GID**).  
- File permissions are tied to user, group, and others - service users should only have access where required.  
- Use `id username` to check a user’s UID, GID, and group memberships.  
- Proper user and permission management is a core part of Linux server security.

---

## Key Learnings

- Service users should not have terminal access in production
- Non-interactive shells improve server security
- User management is a core Linux admin skill

**Next Challenge**: [Day 02 →](Tasks/Day-02.md)
