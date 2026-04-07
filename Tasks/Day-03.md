# Day 03 – Secure Root SSH Access

---

## Task Overview  
Following security audits, the `xFusionCorp Industries` security team has rolled out new protocols including the restriction of direct root SSH login.

Your task is to disable SSH root login on all app server within the Stratos Datacenter.  There are three app servers so the following commands need to run on each server to complete the challenge.

### Servers:
- `stapp01.stratos.xfusioncorp.com` → user: `tony`  
- `stapp02.stratos.xfusioncorp.com` → user: `steve`  
- `stapp03.stratos.xfusioncorp.com` → user: `banner`  

---

## Step-by-Step Implementation  

### Step 1: Connect to Server  
```bash
ssh tony@stapp01.stratos.xfusioncorp.com
```
#### Explanation:
The `ssh` command is used to connect to a remote server securely. We run this to access the server where SSH configuration needs to be updated.

### Step 2: Switch to Root User
```bash
sudo -i
```
#### Explanation:
The `sudo -i` command gives root-level access. We run this because modifying SSH configuration requires administrative privileges.

### Step 3: Locate SSH Configuration File
```bash
ls -lah /etc/ssh
```
#### Explanation:
Lists files inside the SSH directory. We run this to confirm the presence of the sshd_config file.

### Step 4: Edit SSH Configuration
```bash
vi /etc/ssh/sshd_config
```
#### Explanation:
Opens the SSH configuration file using the vi editor. We run this to modify SSH settings.

### Step 5: Disable Root Login
Inside the file, update:
```bash
#LoginGraceTime 2m
PermitRootLogin yes <- Change this from yes to no
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10
```
#### Explanation:
This setting controls whether root login via SSH is allowed. We change it to no to disable direct root login and improve security.

### Step 6: Save and Exit
- `Press i` → enter insert mode
- Make changes
- Press `Esc`
- Type `:wq` → save and exit
#### Explanation:
These are basic vi editor commands used to edit and save configuration files.

### Step 7: Restart SSH Service
```bash
systemctl restart sshd
```
#### Explanation:
`systemctl restart` restarts the service to apply configuration changes. Without this, changes will not take effect.

### Step 8: Verify SSH Service
```bash
systemctl status sshd
```
#### Explanation:
`systemctl status` Checks the current status of the SSH service. We run this to confirm that the service is running properly after restart.

---

## Why Disable Root Login
- Prevents brute-force attacks on root account
- Improves accountability (actions tied to users)
- Enforces use of sudo for privileged access

## Best Practices
- Always disable direct root SSH login
- Use regular users + sudo
- Keep SSH configurations secure
- Regularly audit access logs

## Key Learnings
- Root login is a major security risk
- SSH configuration is critical for system security
- Always restart services after config changes
- Using sudo improves control and auditing

---

Next Challenge: [Day 04 →](Tasks/Day-04.md)
