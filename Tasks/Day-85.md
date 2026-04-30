# Day 85 – Create Files on App Servers using Ansible

---

## Task Overview  
The Nautilus DevOps team is testing various Ansible modules on servers in `Stratos DC`. They're currently focusing on file creation on remote hosts using Ansible. Here are the details:

- Create an inventory file `~/playbook/inventory` on `jump host` and include `all app servers`.

- Create a playbook `~/playbook/playbook.yml` to create a blank file `/opt/webdata.txt` on `all app servers`.

- Set the permissions of the `/opt/webdata.txt` file to `0744`.

- Ensure the user/group owner of the `/opt/webdata.txt` file is `tony` on `app server 1`, `steve` on `app server 2` and `banner` on `app server 3`.

`Note:` Validation will execute the playbook using the command `ansible-playbook -i inventory playbook.yml`, so ensure the playbook functions correctly without any additional arguments.

---

## Step-by-Step Implementation  

### Step 1: Create Playbook Directory  

```bash
mkdir -p ~/playbook
cd ~/playbook
```
#### Explanation:  
The `mkdir -p` command creates directory if it does not exist.  
The `cd` command moves into that directory.  

We run this to organize inventory and playbook files.

---

## 🔹 Configure Inventory  

### Step 2: Create Inventory File  

```yaml
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
- `[app]` defines host group  
- Each server includes login credentials  
- SSH checking disabled to avoid prompts  

We configure this to allow Ansible access to all servers.

---

## 🔹 Create Playbook  

### Step 3: Create Playbook File  

```yaml
cat > ~/playbook/playbook.yml << 'EOF'
---
- name: Create file on App Server 1
  hosts: stapp01
  become: yes
  tasks:
    - name: Create /opt/webdata.txt
      file:
        path: /opt/webdata.txt
        state: touch
        owner: tony
        group: tony
        mode: '0744'

- name: Create file on App Server 2
  hosts: stapp02
  become: yes
  tasks:
    - name: Create /opt/webdata.txt
      file:
        path: /opt/webdata.txt
        state: touch
        owner: steve
        group: steve
        mode: '0744'

- name: Create file on App Server 3
  hosts: stapp03
  become: yes
  tasks:
    - name: Create /opt/webdata.txt
      file:
        path: /opt/webdata.txt
        state: touch
        owner: banner
        group: banner
        mode: '0744'
EOF
```
#### Explanation:  
This command creates the playbook.  
- Each play targets one server  
- `become: yes` enables root privileges  
- `file` module creates file  
- `state: touch` creates empty file  
- `owner`, `group`, `mode` set permissions  

We define this to apply different ownership per server.

### Step 4: Verify Configuration Files  

```bash
cat ~/playbook/inventory
cat ~/playbook/playbook.yml
```
#### Explanation:  
The `cat` command displays file contents. We run this to ensure correct configuration before execution.

---

## 🔹 Testing and Execution  

### Step 5: Test Connectivity  

```bash
ansible -i inventory app -m ping
```
#### Explanation:  
The `ansible` command tests connection to hosts.  
- `-m ping` verifies connectivity  

We run this to ensure all servers are reachable.

### Step 6: Run Playbook  

```bash
ansible-playbook -i inventory playbook.yml
```
#### Explanation:  
The `ansible-playbook` command executes tasks. We run this to create files with correct permissions and ownership.

### Step 7: Verify File on Servers  

```bash
ansible -i inventory app -m shell -a "ls -la /opt/webdata.txt" --become
```
#### Explanation:  
The `shell` module runs command on remote servers.  
The `--become` ensures root privileges.  

We run this to confirm file creation, ownership, and permissions.

---

## Key Learnings  
- Ansible can manage files across multiple servers  
- `file` module supports ownership and permission control  
- Separate plays allow different configurations per host  
- Inventory defines authentication and grouping  
- Always validate connectivity before execution 
