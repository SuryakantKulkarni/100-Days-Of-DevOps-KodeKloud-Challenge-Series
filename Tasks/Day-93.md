# Day 93 – Using Ansible Conditionals

---

## Task Overview  
The Nautilus DevOps team had a discussion about, how they can train different team members to use Ansible for different automation tasks. There are numerous ways to perform a particular task using Ansible, but we want to utilize each aspect that Ansible offers. The team wants to utilise Ansible's conditionals to perform the following task:

An `inventory` file is already placed under `/home/thor/ansible` directory on `jump host`, with all the `Stratos DC app servers` included.

Create a playbook `/home/thor/ansible/playbook.yml` and make sure to use Ansible's `when` conditionals statements to perform the below given tasks.

- Copy `blog.txt` file present under `/usr/src/finance` directory on `jump host` to `App Server 1` under `/opt/finance` directory. Its user and group owner must be user `tony` and its permissions must be `0755` .

-  Copy `story.txt` file present under `/usr/src/finance` directory on `jump host` to `App Server 2` under `/opt/finance` directory. Its user and group owner must be user `steve` and its permissions must be `0755` .

- Copy `media.txt` file present under `/usr/src/finance` directory on `jump host` to `App Server 3` under `/opt/finance` directory. Its user and group owner must be user `banner` and its permissions must be `0755`.

`NOTE:` You can use `ansible_nodename` variable from gathered facts with `when` condition. Additionally, please make sure you are running the play for all hosts i.e use `- hosts: all`.

`Note:` Validation will try to run the playbook using command `ansible-playbook -i inventory playbook.yml`, so please make sure the playbook works this way without passing any extra arguments.

---

## Step-by-Step Implementation  

### Step 1: Check Existing Files  

```bash
cat /home/thor/ansible/inventory

ls /usr/src/finance/
```
#### Explanation:  
The `cat` command displays inventory content.  
The `ls` command lists available source files.  

We run this to verify inventory configuration and required files.

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
This command updates inventory file with all app servers and credentials. We ensure Ansible can connect to all target systems.

---

## 🔹 Create Playbook  

### Step 3: Create Playbook File  

```bash
cat > /home/thor/ansible/playbook.yml << 'EOF'
---
- name: Copy files using Ansible conditionals
  hosts: all
  become: yes
  tasks:

    - name: Create finance directory
      file:
        path: /opt/finance
        state: directory
        mode: '0755'

    - name: Copy blog.txt to App Server 1
      copy:
        src: /usr/src/finance/blog.txt
        dest: /opt/finance/blog.txt
        owner: tony
        group: tony
        mode: '0755'
      when: ansible_nodename == "stapp01"

    - name: Copy story.txt to App Server 2
      copy:
        src: /usr/src/finance/story.txt
        dest: /opt/finance/story.txt
        owner: steve
        group: steve
        mode: '0755'
      when: ansible_nodename == "stapp02"

    - name: Copy media.txt to App Server 3
      copy:
        src: /usr/src/finance/media.txt
        dest: /opt/finance/media.txt
        owner: banner
        group: banner
        mode: '0755'
      when: ansible_nodename == "stapp03"
EOF
```
#### Explanation:  
This command creates the playbook.  
- `hosts: all` runs tasks on all servers  
- `copy` module transfers files  
- `when` condition controls task execution  
- `ansible_nodename` identifies current server  

We use conditionals to apply different tasks per server.

### Step 4: Verify Configuration Files  

```bash
cat /home/thor/ansible/inventory

cat /home/thor/ansible/playbook.yml
```
#### Explanation:  
Displays inventory and playbook content. We run this to confirm correct configuration before execution.

---

## 🔹 Testing and Execution  

### Step 5: Test Connectivity  

```bash
cd /home/thor/ansible

ansible -i inventory all -m ping
```
#### Explanation:  
The `ping` module checks connectivity with all servers. We run this to ensure Ansible can reach all app servers.

### Step 6: Syntax Check  

```bash
ansible-playbook -i inventory playbook.yml --syntax-check
```
#### Explanation:  
The `--syntax-check` option validates YAML syntax without execution. We run this to detect playbook errors before deployment.

### Step 7: Run Playbook  

```bash
ansible-playbook -i inventory playbook.yml
```
#### Explanation:  
The `ansible-playbook` command executes automation tasks. We run this to copy files conditionally to target servers.

### Step 8: Verify on Servers  

```bash
ansible -i inventory stapp01 -m shell -a "ls -la /opt/finance/blog.txt" --become

ansible -i inventory stapp02 -m shell -a "ls -la /opt/finance/story.txt" --become

ansible -i inventory stapp03 -m shell -a "ls -la /opt/finance/media.txt" --become
```
#### Explanation:  
The `shell` module runs verification commands remotely. We run this to confirm correct file deployment, ownership, and permissions.

### Expected Output  

```bash
stapp01 | -rwxr-xr-x 1 tony   tony   /opt/finance/blog.txt
stapp02 | -rwxr-xr-x 1 steve  steve  /opt/finance/story.txt
stapp03 | -rwxr-xr-x 1 banner banner /opt/finance/media.txt
```

---

## Key Learnings  
- `when` condition controls task execution dynamically  
- `ansible_nodename` identifies target host  
- `hosts: all` runs playbook on multiple servers  
- Conditional tasks improve playbook flexibility  
- Automation reduces repetitive manual configuration  
