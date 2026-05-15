# Day 84 – Copy Data to App Servers using Ansible

---

## Task Overview  
The Nautilus DevOps team needs to copy data from the `jump host` to all `application servers` in `Stratos DC` using Ansible. Execute the task with the following details:

- Create an inventory file `/home/thor/ansible/inventory` on `jump_host` and add all application servers as managed nodes.

- Create a playbook `/home/thor/ansible/playbook.yml` on the `jump host` to copy the `/usr/src/security/index.html` file to all application servers, placing it at `/opt/security`.

`Note:` Validation will run the playbook using the command `ansible-playbook -i inventory playbook.yml`. Ensure the playbook functions properly without any extra arguments.

---

## Step-by-Step Implementation  

### Step 1: Navigate to Ansible Directory  

```bash
cd /home/thor/ansible
ls -la
```
#### Explanation:  
The `cd` command changes the working directory to the Ansible folder.  
The `ls -la` command lists all files with permissions and hidden files.  

We run this to confirm the working directory and existing files.

### Step 2: Verify Source File  

```bash
cat /usr/src/security/index.html
```
#### Explanation:  
The `cat` command displays file content. We run this to ensure the source file exists and is ready to be copied.

---

## 🔹 Configure Inventory  

### Step 3: Create Inventory File  

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
This command creates the inventory file using a here-document.  
- `[app]` defines a group of servers  
- Each host includes SSH credentials  
- `StrictHostKeyChecking=no` disables SSH prompt  

We configure this so Ansible can connect to all servers automatically.

---

## 🔹 Create Playbook  

### Step 4: Create Playbook File  

```yaml
cat > /home/thor/ansible/playbook.yml << 'EOF'
---
- name: Copy index.html to all app servers
  hosts: app
  become: yes
  tasks:

    - name: Create directory /opt/security
      file:
        path: /opt/security
        state: directory
        mode: '0755'

    - name: Copy file to servers
      copy:
        src: /usr/src/security/index.html
        dest: /opt/security/index.html
EOF
```

#### Explanation:  
This command creates the playbook file.  
- `hosts: app` targets all servers  
- `become: yes` enables root privileges  
- `file` module creates directory  
- `copy` module transfers file  

We use this to automate file distribution across all servers.

### Step 5: Verify Configuration Files  

```bash
cat /home/thor/ansible/inventory
cat /home/thor/ansible/playbook.yml
```
#### Explanation:  
The `cat` command displays file contents. We run this to verify that both inventory and playbook are correct.

---

## 🔹 Testing and Execution  

### Step 6: Test Connectivity  

```bash
ansible -i inventory app -m ping
```
#### Explanation:  
The `ansible` command runs a test module.  
- `-i inventory` specifies inventory file  
- `-m ping` checks connectivity  

We run this to ensure all servers are reachable.

### Step 7: Run Playbook  

```bash
ansible-playbook -i inventory playbook.yml
```
#### Explanation:  
The `ansible-playbook` command executes the playbook. We run this to create directory and copy the file to all servers

### Step 8: Verify File on Servers  

```bash
ansible -i inventory app -m shell -a "ls -la /opt/security/index.html" --become
```
#### Explanation:  
The `shell` module runs commands on remote servers.  
The `--become` flag ensures root access.  

We run this to confirm the file exists on all servers.

---

## Key Learnings  
- Inventory defines multiple target hosts  
- Playbooks automate tasks across servers  
- `copy` module transfers files efficiently  
- `file` module manages directories and permissions  
- Always validate connectivity before execution 
