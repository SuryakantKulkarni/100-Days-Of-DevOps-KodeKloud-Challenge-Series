# Day 87 – Ansible Install Package

---

## Task Overview  
The Nautilus Application development team wanted to test some applications on app servers in `Stratos Datacenter`. They shared some pre-requisites with the DevOps team, and packages need to be installed on app servers. Since we are already using Ansible for automating such tasks, please perform this task using Ansible as per details mentioned below: 

- Create an inventory file `/home/thor/playbook/inventory` on `jump host` and add all app servers in it.

- Create an Ansible playbook `/home/thor/playbook/playbook.yml` to install `chrony` package on `all app servers` using Ansible `yum` module.

- Make sure user `thor` should be able to run the playbook on `jump host`.

`Note:` Validation will try to run playbook using command `ansible-playbook -i inventory playbook.yml` so please make sure playbook works this way, without passing any extra arguments.

---

## Step-by-Step Implementation  

### Step 1: Create Playbook Directory  

```bash
mkdir -p ~/playbook
cd ~/playbook
```
#### Explanation:  
The `mkdir -p` command creates directory if not exists.  
The `cd` command moves into that directory.  

We run this to organize Ansible inventory and playbook files.

---

## 🔹 Configure Inventory  

### Step 2: Create Inventory File  

```bash
cat > ~/playbook/inventory << 'EOF'
[app]
stapp01 ansible_user=tony ansible_ssh_pass=Ir0nM@n
stapp02 ansible_user=steve ansible_ssh_pass=Am3ric@
stapp03 ansible_user=banner ansible_ssh_pass=BigGr33n

[app:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF
```
#### Explanation:  
This command creates the inventory file.  
- `[app]` defines group of servers  
- Each host includes SSH credentials  
- SSH checking disabled to avoid prompts  

We configure this so Ansible can connect to all app servers.

---

## 🔹 Create Playbook  

### Step 3: Create Playbook File  

```yaml
cat > ~/playbook/playbook.yml << 'EOF'
---
- name: Install chrony on all app servers
  hosts: app
  become: yes
  tasks:
    - name: Install chrony package
      yum:
        name: chrony
        state: present
EOF
```
#### Explanation:  
This command creates the playbook file.  
- `hosts: app` targets all servers  
- `become: yes` enables root privileges  
- `yum` module installs package  
- `state: present` ensures package is installed  

We use this to automate package installation across servers.

### Step 4: Verify Configuration Files  

```bash
cat ~/playbook/inventory
cat ~/playbook/playbook.yml
```
#### Explanation:  
The `cat` command displays file contents. We run this to ensure both files are correctly written.

---

## 🔹 Testing and Execution  

### Step 5: Test Connectivity  

```bash
ansible -i inventory app -m ping
```
#### Explanation:  
The `ansible` command tests connection.  
- `-m ping` checks host reachability  

We run this to ensure all servers are accessible.

### Step 6: Run Playbook  

```bash
ansible-playbook -i inventory playbook.yml
```
#### Explanation:  
The `ansible-playbook` command executes tasks. We run this to install the chrony package on all servers.

### Step 7: Verify Installation  

```bash
ansible -i inventory app -m shell -a "rpm -qa | grep chrony" --become
```
#### Explanation:  
The `shell` module runs command on remote servers.  
The `--become` ensures root access.  

We run this to confirm chrony package is installed.

---

## Key Learnings  
- `yum` module installs packages via Ansible  
- `state: present` ensures idempotent installation  
- Inventory defines multiple hosts  
- Playbooks automate repetitive tasks  
- Always verify installation after execution 
