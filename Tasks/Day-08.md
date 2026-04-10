# Day 08 – Install Ansible

---

## Task Overview  
During the weekly meeting, the Nautilus DevOps team discussed about the automation and configuration management solutions that they want to implement. While considering several options, the team has decided to go with `Ansible` for now due to its simple setup and minimal pre-requisites. The team wanted to start testing using Ansible, so they have decided to use jump host as an Ansible controller to test different kind of tasks on rest of the servers.

Install `ansible` version `4.9.0` on `Jump host` using `pip3` only. Make sure Ansible binary is available globally on this system, i.e all users on this system are able to run Ansible commands.

---

## Step-by-Step Implementation  

### Step 1: Install Ansible  
```bash
sudo pip3 install ansible==4.9.0
```
#### Explanation:  
The `pip3 install ansible==4.8.0` command installs a specific version of Ansible using Python’s package manager.

The `sudo` keyword ensures the installation happens at the system level so that all users can access the Ansible binary.

The `pip3` tool is used to install Python packages, and Ansible is distributed as a Python package.

We run this command to install Ansible globally on the system.

### Step 2: Verify Ansible Installation  
```bash
ansible --version
```
#### Explanation:  
The `ansible --version` command displays the installed version of Ansible along with additional details such as Python version, module paths, and configuration file location.

We run this command to verify successful installation.

### Step 3: Ensure Global Accessibility (Important)  
```bash
sudo ansible --version
```
#### Explanation:  
The `sudo ansible --version` command checks whether Ansible is accessible for root users as well.

Sometimes, Ansible installed via pip3 is located in `/usr/local/bin`, which may not be included in the default secure path for sudo users. If this command fails, it means Ansible is not available globally for all users.

We run this command to confirm global accessibility.

### Step 4: Fix PATH Issue (if required)  
```bash
sudo visudo
```
#### Explanation:  
The `visudo` command is used to safely edit the sudoers file, which controls sudo permissions and environment variables.

Inside the file, locate the `secure_path` variable and add `/usr/local/bin` to it:

```bash
Defaults secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
```

This ensures that Ansible binary installed via pip3 is accessible to all users, including sudo users.

We run this step only if Ansible is not available globally.

---

## Best Practices  
- Use specific Ansible version  
- Verify installation after setup  
- Maintain proper PATH configuration  
- Use virtual environments for testing  

## Key Learnings  
- Ansible is agentless and easy to set up  
- pip3 provides version control flexibility  
- PATH configuration is critical for global access  
- Essential tool for DevOps automation  
