# Day 88 – Ansible Blockinfile Module

---

## Task Overview  
The Nautilus DevOps team wants to install and set up a simple `httpd` web server on all app servers in `Stratos DC`. Additionally, they want to deploy a sample web page for now using Ansible only. Therefore, write the required playbook to complete this task. Find more details about the task below.

We already have an `inventory` file under `/home/thor/ansible` directory on `jump host`. Create a `playbook.yml` under `/home/thor/ansible` directory on `jump host` itself.

- Using the playbook, install `httpd` web server on all app servers. Additionally, make sure its service should up and running.

- Using `blockinfile` Ansible module add some content in `/var/www/html/index.html` file. Below is the content:
  
  `Welcome to XfusionCorp!`

  `This is Nautilus sample file, created using Ansible!`

  `Please do not modify this file manually!`

- The `/var/www/html/index.html` file's user and group `owner` should be `apache` on all app servers.

- The `/var/www/html/index.html` file's permissions should be `0755` on all app servers.
  
`Note:`

- Validation will try to run the playbook using command `ansible-playbook -i inventory playbook.yml` so please make sure the playbook works this way without passing any extra arguments.

- Do not use any custom or empty `marker` for `blockinfile` module.

---

## Step-by-Step Implementation  

### Step 1: Check Inventory File  

```bash
cat /home/thor/ansible/inventory
```

#### Explanation:  
The `cat` command displays inventory content. We run this to verify all app servers are defined correctly.

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
- Defines all servers and credentials  
- Disables SSH prompt  

We ensure Ansible can connect to all servers.

---

## 🔹 Create Playbook  

### Step 3: Create Playbook File  

```bash
cat > /home/thor/ansible/playbook.yml << 'EOF'
---
- name: Install and configure httpd on all app servers
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

    - name: Create index.html file
      file:
        path: /var/www/html/index.html
        state: touch
        owner: apache
        group: apache
        mode: '0755'

    - name: Add content using blockinfile
      blockinfile:
        path: /var/www/html/index.html
        block: |
          Welcome to XfusionCorp!
          This is Nautilus sample file, created using Ansible!
          Please do not modify this file manually!

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
- `yum` installs httpd  
- `service` starts and enables service  
- `file` creates and manages file  
- `blockinfile` inserts content block  
- Final task ensures ownership and permissions  

We use this to fully automate web server setup.

### Step 4: Verify Configuration Files  

```bash
cat /home/thor/ansible/inventory
cat /home/thor/ansible/playbook.yml
```
#### Explanation:  
Displays both files. We run this to confirm correct configuration.

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
The `ansible-playbook` command executes all tasks. We run this to install httpd and deploy webpage.

### Step 7: Verify on Servers  

```bash
ansible -i inventory app -m shell -a "cat /var/www/html/index.html" --become

ansible -i inventory app -m shell -a "ls -la /var/www/html/index.html" --become

ansible -i inventory app -m shell -a "systemctl status httpd" --become
```
#### Explanation:  
- First command checks file content  
- Second checks permissions and ownership  
- Third verifies service status  

We run this to confirm full setup is successful.

---

## Key Learnings  
- `blockinfile` inserts managed content blocks  
- Ansible ensures idempotent configuration  
- Services can be managed using `service` module  
- File ownership and permissions are critical  
- Automation ensures consistency across servers 
