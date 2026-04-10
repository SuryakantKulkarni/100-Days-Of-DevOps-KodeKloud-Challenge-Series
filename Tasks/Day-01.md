# Day 01 – Linux User Setup with Non-interactive Shell

---

## Task Overview
The system admin team at `xFusionCorp Industries` needed to set up a user account specifically for a backup agent tool. Since this tool doesn’t require interactive login, the requirement was to create a `user` with a `non-interactive shell`.

Create a user named `mark` with a `non-interactive shell` on `App Server 2`.

---

## Step-by-Step Implementation 

### Step 1: Connect to the application server via SSH
```bash
ssh steve@app-server-2
```
#### Explanation:
Connect to the server using `SSH`. Replace user with your actual username and server-name or app-server-ip with the server details. This lets you securely access the Linux server from your local machine.

### Step 2: Create a user with a non-interactive shell
```bash
sudo useradd -m -s /usr/sbin/nologin user-name
```
#### Explanation:
The `useradd` command creates a new system user account with restricted shell access.
- `-m` flag creates a home directory at /home/user-name.
- `-s` /usr/sbin/nologin assigns a non-interactive shell, preventing terminal logins.

This setup is ideal for service accounts, automation users, or application runtime users that should exist on the system but must not have interactive access. Replace user-name with the username required by the task.

### Step 3: Verify user creation in the system database
```bash
cat /etc/passwd
```
#### Explanation:
The `cat` command displays user account entries stored on the system. Look for the newly created user entry, which should appear like:

```bash
username:x:1003:1004::/home/username:/usr/sbin/nologin
```
This confirms:
- The user exists
- The home directory is set
- The login shell is /usr/sbin/nologin, which disables interactive access

> **Tip:** You can also use ``getent passwd user-name`` for a cleaner, targeted check.

### Step 4: Test that interactive login is blocked
```bash
sudo su user-name
```
#### Explanation:
This command attempts to switch to the newly created user. The command should fail with a message like:

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

## Security Best Practices  
- Always use non-interactive shells for service accounts, bots, and automation users.  
- Never run applications as `root`; create dedicated service users for each service where possible.  
- Limit permissions for service users to only the files and directories they need.  
- Disable password login for service users if they don’t need to authenticate interactively.  
- This approach reduces the impact of compromised credentials and follows the **principle of least privilege**.

## Key Learnings
- Service users should not have terminal access in production
- Non-interactive shells improve server security
- User management is a core Linux admin skill
