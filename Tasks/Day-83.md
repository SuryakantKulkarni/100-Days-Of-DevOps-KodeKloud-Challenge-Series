# Day 83 – Troubleshoot and Create Ansible Playbook

---

## Task Overview  
An Ansible playbook needs completion on the `jump host`, where a team member left off. Below are the details:

- The inventory file `/home/thor/ansible/inventory` requires adjustments. The playbook must run on `App Server 1` in `Stratos DC`. Update the inventory accordingly.

- Create a playbook `/home/thor/ansible/playbook.yml`. Include a task to create an empty file `/tmp/file.txt` on `App Server 1`.

`Note:` Validation will run the playbook using the command `ansible-playbook -i inventory playbook.yml`. Ensure the playbook works without any additional arguments.

---

## Step-by-Step Implementation  

### Step 1: Navigate to Ansible Directory  

```bash
cd /home/thor/ansible
ls -la
```
#### Explanation:  
The `cd` command changes the working directory to the Ansible project folder.  
The `ls -la` command lists all files with details including hidden files.  

We run this to check existing inventory and playbook files before making changes.

### Step 2: Check Existing Files  

```bash
cat inventory
cat playbook.yml
```
#### Explanation:  
The `cat` command displays file contents. We run this to inspect current configuration and identify required fixes.

---

## 🔹 Configure Inventory  

### Step 3: Create / Update Inventory File  

```bash
cat > /home/thor/ansible/inventory << 'EOF'
[app]
stapp01

[app:vars]
ansible_user=tony
ansible_ssh_pass=Ir0nM@n
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF
```
#### Explanation:  
This command creates or overwrites the inventory file.  
- `[app]` defines a host group  
- `stapp01` is the target server  
- `ansible_user` defines SSH user  
- `ansible_ssh_pass` sets password  
- `StrictHostKeyChecking=no` avoids SSH prompt  

We configure this so Ansible can connect to App Server 1 automatically.

---

## 🔹 Create Playbook  

### Step 4: Create Playbook File  

```bash
cat > /home/thor/ansible/playbook.yml << 'EOF'
---
- name: Create empty file on App Server 1
  hosts: app
  become: yes
  tasks:
    - name: Create empty file /tmp/file.txt
      file:
        path: /tmp/file.txt
        state: touch
EOF
```
#### Explanation:  
This command creates the Ansible playbook file.  
- `hosts: app` targets defined group  
- `become: yes` enables root privileges  
- `file` module manages files  
- `state: touch` creates file if not exists  

We run this to define automation task for file creation.

### Step 5: Verify Configuration Files  

```bash
cat /home/thor/ansible/inventory
cat /home/thor/ansible/playbook.yml
```
#### Explanation:  
The `cat` command verifies file contents. We run this to ensure both inventory and playbook are correctly written.

---

## 🔹 Testing and Execution  

### Step 6: Test Connectivity  

```bash
ansible -i inventory app -m ping
```
#### Explanation:  
The `ansible` command runs an ad-hoc module.  
- `-i inventory` specifies inventory file  
- `-m ping` tests connection  

We run this to confirm Ansible can reach the server successfully.

### Step 7: Run Playbook  

```bash
ansible-playbook -i inventory playbook.yml
```
#### Explanation:  
The `ansible-playbook` command executes the playbook.  
- `-i inventory` specifies hosts file  

We run this to apply automation and create the file.

### Step 8: Verify File Creation  

```bash
ssh tony@stapp01 "ls -la /tmp/file.txt"
```
#### Explanation:  
The `ssh` command connects to remote server and runs a command.  
The `ls -la` confirms file existence and permissions.  

We run this to verify the playbook executed successfully.

---

## Key Learnings  
- Ansible inventory defines target hosts and credentials  
- Playbooks automate tasks using YAML format  
- `file` module is used for file management  
- `become` enables privilege escalation  
- Always test connectivity before running playbook 
