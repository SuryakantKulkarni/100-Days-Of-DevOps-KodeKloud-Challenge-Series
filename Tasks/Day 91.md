# Day 91 – Ansible Lineinfile Module

---

## Task Overview  
The Nautilus DevOps team want to install and set up a simple `httpd` web server on all app servers in `Stratos DC`. They also want to deploy a sample web page using Ansible. Therefore, write the required playbook to complete this task as per details mentioned below.

We already have an `inventory` file under `/home/thor/ansible directory` on `jump host`. Write a playbook `playbook.yml` under `/home/thor/ansible` directory on `jump host` itself. Using the playbook perform below given tasks:

- Install `httpd` web server on all app servers, and make sure its service is up and running.

- Create a file `/var/www/html/index.html` with content:

  `This is a Nautilus sample file, created using Ansible!`

- Using `lineinfile` Ansible module add some more content in `/var/www/html/index.html` file. Below is the content:

  `Welcome to Nautilus Group!`

  Also make sure this new line is added at the top of the file.

- The `/var/www/html/index.html` file's user and group `owner` should be `apache` on all app servers.

- The `/var/www/html/index.htm`l file's permissions should be `0755` on all app servers.

`Note:` Validation will try to run the playbook using command `ansible-playbook -i inventory playbook.yml` so please make sure the playbook works this way without passing any extra arguments.

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
This command updates inventory with all app servers and credentials. We ensure Ansible connectivity across all servers.

---

## 🔹 Create Playbook  

### Step 3: Create Playbook File  

```bash
cat > /home/thor/ansible/playbook.yml << 'EOF'
---
- name: Install httpd and configure webpage
  hosts: app
  become: yes
  tasks:

    - name: Install httpd package
      yum:
        name: httpd
        state: present

    - name: Start and enable httpd service
      service:
        name: httpd
        state: started
        enabled: yes

    - name: Create index.html with initial content
      copy:
        content: "This is a Nautilus sample file, created using Ansible!"
        dest: /var/www/html/index.html
        owner: apache
        group: apache
        mode: '0755'

    - name: Add welcome line at top using lineinfile
      lineinfile:
        path: /var/www/html/index.html
        line: "Welcome to Nautilus Group!"
        insertbefore: BOF

    - name: Set ownership and permissions
      file:
        path: /var/www/html/index.html
        owner: apache
        group: apache
        mode: '0755'
EOF
```
#### Explanation:  
This command creates the playbook.  
- `yum` installs httpd package  
- `service` starts and enables service  
- `copy` creates file with content  
- `lineinfile` inserts line at beginning of file  
- `file` ensures correct ownership and permissions  

We use this to automate web server and webpage deployment.

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
cd /home/thor/ansible
ansible -i inventory app -m ping
```
#### Explanation:  
The `ping` module checks connectivity with all servers. We run this to ensure Ansible can reach all app servers.

### Step 6: Run Playbook  

```bash
ansible-playbook -i inventory playbook.yml
```
#### Explanation:  
The `ansible-playbook` command executes all tasks. We run this to install httpd and configure webpage content.

### Step 7: Verify on Servers  

```bash
ansible -i inventory app -m shell -a "cat /var/www/html/index.html" --become

ansible -i inventory app -m shell -a "ls -la /var/www/html/index.html" --become

ansible -i inventory app -m shell -a "systemctl status httpd | grep Active" --become
```
#### Explanation:  
- First command checks webpage content  
- Second verifies ownership and permissions  
- Third confirms httpd service is running  

We run this to validate successful configuration.

---

## Key Learnings  
- `lineinfile` manages single line changes in files  
- `insertbefore: BOF` adds line at top of file  
- `copy` module creates files with content  
- Ansible automates service management and configuration  
- Proper permissions improve security and consistency  
