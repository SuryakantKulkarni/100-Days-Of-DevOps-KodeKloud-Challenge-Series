# Day 05 – SELinux Installation and Configuration

---

## Task Overview  
Following a security audit, the xFusionCorp Industries security team has opted to enhance application and server security with SELinux. To initiate testing, the following requirements have been established for `App server 2` in the `Stratos Datacenter`:

- Install the required `SELinux` packages.
- Permanently disable SELinux for the time being; it will be re-enabled after necessary configuration changes.
- No need to reboot the server, as a scheduled maintenance reboot is already planned for tonight.
- Disregard the current status of SELinux via the command line; the final status after the reboot should be `disabled`.

---

## Step-by-Step Implementation  

### Step 1: Connect to Server  
```bash
ssh steve@stapp02.stratos.xfusioncorp.com
```
#### Explanation:
The `ssh` command is used to connect to the remote server. We run this to access App Server 2.

### Step 2: Check OS Version
```bash
cat /etc/os-release
```
#### Explanation:
Displays OS details. We run this to confirm compatibility for SELinux packages.

### Step 3: Check if SELinux Packages are Installed
```bash
rpm -q policycoreutils selinux-policy
```
Explanation:
The `rpm -q` command checks if packages are installed. We run this to verify whether SELinux tools are already present.

### Step 4: Install SELinux Packages
```bash
sudo dnf install -y policycoreutils policycoreutils-python-utils selinux-policy selinux-policy-targeted
```
#### Explanation:
The dnf install command installs required packages.
- `policycoreutils` → SELinux utilities
- `selinux-policy` → SELinux rules
- `selinux-policy-targeted` → default policy
- `-y` → auto-confirm installation
We run this to install all necessary SELinux components.

### Step 5: Verify SELinux Config File
```bash
ls /etc/selinux
```
#### Explanation:
Lists SELinux configuration directory. We run this to locate the main config file.

### Step 6: Edit SELinux Configuration
```bash
sudo vi /etc/selinux/config
```
#### Explanation:
Opens SELinux config file using `vi`. We run this to modify SELinux mode.

### Step 7: Disable SELinux

Change:
```bash
SELINUX=enforcing
```
To:
```bash
SELINUX=disabled
```
#### Explanation:
This setting controls SELinux mode. We set it to disabled so it remains off after reboot.

---

## Key Concepts

### SELinux (Security-Enhanced Linux)
- Provides Mandatory Access Control (MAC)
- Adds extra security layer to Linux systems
- Controls how processes access files

### SELinux Modes
- `Enforcing` → Policies are applied
- `Permissive` → Logs violations but allows actions
- `Disabled` → SELinux is turned off
  
### SELinux Policies
- `targeted` → Default policy (protects specific services)
- `MLS` → Multi-Level Security (advanced use)
  
### SELinux Context
- **Format:** `user:role:type:level`
- Defines permissions for files and processes

### Additional Commands
- `getenforce` → Check current mode
- `setenforce 0` → Set permissive mode (temporary)
- `setenforce 1` → Set enforcing mode
- `sestatus` → Detailed SELinux status
  
### Configuration Files
- `/etc/selinux/config` → Main configuration
- `/var/log/audit/audit.log` → SELinux logs
- `/etc/selinux/targeted/` → Policy files

---
  
## Security Best Practices
- Use SELinux in enforcing mode in production
- Avoid disabling SELinux permanently
- Test changes in permissive mode first
- Monitor logs for denied actions

## Key Learnings
- SELinux adds an extra layer of security
- It uses policies to control access
- Configuration changes require proper understanding
- Disabling SELinux should be temporary only
- Important for production system security

---

Next Challenge: [Day 06 →](Tasks/Day-06.md)
