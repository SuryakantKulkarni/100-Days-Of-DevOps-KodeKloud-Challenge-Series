# Day 89 – Ansible Manage Services

---

## Task Overview  
Developers are looking for dependencies to be installed and run on Nautilus app servers in Stratos DC. They have shared some requirements with the DevOps team. Because we are now managing packages installation and services management using Ansible, some playbooks need to be created and tested. As per details mentioned below please complete the task: 

- On `jump host` create an Ansible playbook `/home/thor/ansible/playbook.yml` and configure it to install vsftpd on all app servers.

- After installation make sure to start and enable `vsftpd` service on all app servers.

- The inventory `/home/thor/ansible/inventory` is already there on `jump host`.

- Make sure user `thor` should be able to run the playbook on `jump host`.

`Note:` Validation will try to run playbook using command `ansible-playbook -i inventory playbook.yml` so please make sure playbook works this way, without passing any extra arguments.

---

## Step-by-Step Implementation  

### Step 1: Check Inventory File  

```bash
cat /home/thor/ansible/inventory
```
#### Explanation:  
The `cat` command displays inventory content. We run this to verify all app servers are already configured.

---

## 🔹 Configure Inventory  

### Step 2: Update Inventory (if needed)  

```bash
cat > /home/thor/ansible/inventory << 'EOF'
[app]
stapp01 ansible_user=tony ansible_ssh_pass=Ir0nM@n
stapp02 ansible_user=steve ansible_ssh_pass=Am3ric@
stapp03 ansible_user=banner ansible_ssh_pass=BigGr33n

[app:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF
```
#### Explanation:  
This command updates inventory file.  
- Lists all app servers  
- Defines SSH credentials  
- Disables SSH prompt  

We ensure Ansible connectivity across all servers.

---

## 🔹 Create Playbook  

### Step 3: Create Playbook File  

```bash
cat > /home/thor/ansible/playbook.yml << 'EOF'
---
- name: Install and configure vsftpd on all app servers
  hosts: app
  become: yes
  tasks:

    - name: Install vsftpd package
      yum:
        name: vsftpd
        state: present

    - name: Start and enable vsftpd service
      service:
        name: vsftpd
        state: started
        enabled: yes
EOF
```
#### Explanation:  
This command creates the playbook.  
- `yum` installs vsftpd package  
- `service` starts service  
- `enabled: yes` ensures auto-start on boot  

We use this to automate service installation and management.

### Step 4: Verify Configuration Files  

```bash
cat /home/thor/ansible/inventory
cat /home/thor/ansible/playbook.yml
```
#### Explanation:  
Displays inventory and playbook content. We run this to confirm correct configuration.

---

## 🔹 Testing and Execution  

### Step 5: Test Connectivity  

```bash
ansible -i inventory app -m ping
```
#### Explanation:  
The `ping` module checks server connectivity. We run this to ensure all servers are reachable.

### Step 6: Run Playbook  

```bash
ansible-playbook -i inventory playbook.yml
```
#### Explanation:  
The `ansible-playbook` command executes tasks. We run this to install and configure vsftpd service.

### Step 7: Verify Service  

```bash
ansible -i inventory app -m shell -a "rpm -qa | grep vsftpd" --become

ansible -i inventory app -m shell -a "systemctl status vsftpd" --become

ansible -i inventory app -m shell -a "systemctl is-enabled vsftpd" --become
```
#### Explanation:  
- First command checks package installation  
- Second verifies service running state  
- Third confirms service is enabled  

We run this to validate full service setup.

---

## Key Learnings  
- Ansible can manage both packages and services  
- `service` module controls service lifecycle  
- `enabled` ensures service starts on boot  
- Automation ensures consistency across servers  
- Always verify service status after deployment 
