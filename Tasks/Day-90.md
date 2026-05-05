# Day 90 – Managing ACLs Using Ansible

---

## Task Overview  
There are some files that need to be created on all app servers in `Stratos DC`. The Nautilus DevOps team want these files to be owned by user `root` only however, they also want that the app specific user to have a set of permissions on these files. All tasks must be done using Ansible only, so they need to create a playbook. Below you can find more information about the task.

Create a playbook named `playbook.yml` under `/home/thor/ansible` directory on `jump host`, an `inventory` file is already present under `/home/thor/ansible` directory on `Jump Server` itself.

- Create an empty file `blog.txt` under `/opt/devops/` directory on `app server 1`. Set some `acl` properties for this file. Using `acl` provide `read '(r)'` permissions to `group tony` (i.e `entity` is `tony` and `etype` is `group`).

- Create an empty file `story.txt` under `/opt/devops/` directory on `app server 2`. Set some `acl` properties for this file. Using `acl` provide `read + write '(rw)'` permissions to `user steve` (i.e `entity` is `steve` and `etype` is `user`).

- Create an empty file `media.txt` under `/opt/devops/` on `app server 3`. Set some `acl` properties for this file. Using `acl` provide `read + write '(rw)'` permissions to `group banner` (i.e `entity` is `banner` and `etype` is `group`).

`Note:` Validation will try to run the playbook using command `ansible-playbook -i inventory playbook.yml` so please make sure the playbook works this way, without passing any extra arguments.

---

## Step-by-Step Implementation  

### Step 1: Check Inventory File  

```bash
cat /home/thor/ansible/inventory
```
#### Explanation:  
The `cat` command displays inventory content. We run this to verify all app servers are configured.

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
This command updates inventory file with all servers and credentials. We ensure Ansible connectivity across all nodes.

---

## 🔹 Create Playbook  

### Step 3: Create Playbook File  

```yaml
cat > /home/thor/ansible/playbook.yml << 'EOF'
---
- name: Configure blog.txt on App Server 1
  hosts: stapp01
  become: yes
  tasks:

    - name: Create directory
      file:
        path: /opt/devops
        state: directory
        owner: root
        group: root
        mode: '0755'

    - name: Create blog.txt
      file:
        path: /opt/devops/blog.txt
        state: touch
        owner: root
        group: root

    - name: Set ACL for group tony
      acl:
        path: /opt/devops/blog.txt
        entity: tony
        etype: group
        permissions: r
        state: present

- name: Configure story.txt on App Server 2
  hosts: stapp02
  become: yes
  tasks:

    - name: Create directory
      file:
        path: /opt/devops
        state: directory
        owner: root
        group: root
        mode: '0755'

    - name: Create story.txt
      file:
        path: /opt/devops/story.txt
        state: touch
        owner: root
        group: root

    - name: Set ACL for user steve
      acl:
        path: /opt/devops/story.txt
        entity: steve
        etype: user
        permissions: rw
        state: present

- name: Configure media.txt on App Server 3
  hosts: stapp03
  become: yes
  tasks:

    - name: Create directory
      file:
        path: /opt/devops
        state: directory
        owner: root
        group: root
        mode: '0755'

    - name: Create media.txt
      file:
        path: /opt/devops/media.txt
        state: touch
        owner: root
        group: root

    - name: Set ACL for group banner
      acl:
        path: /opt/devops/media.txt
        entity: banner
        etype: group
        permissions: rw
        state: present
EOF
```
#### Explanation:  
This command creates the playbook.  
- `file` module creates directory and files  
- `acl` module sets access control  
- Each play targets specific server  
- Permissions applied as per requirement  

We use this to manage fine-grained access control.

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
The `ping` module checks connectivity. We run this to ensure all servers are reachable.

### Step 6: Run Playbook  

```bash
ansible-playbook -i inventory playbook.yml
```
#### Explanation:  
The `ansible-playbook` command executes tasks. We run this to create files and apply ACL permissions.

### Step 7: Verify ACL  

```bash
ansible -i inventory stapp01 -m shell -a "getfacl /opt/devops/blog.txt" --become

ansible -i inventory stapp02 -m shell -a "getfacl /opt/devops/story.txt" --become

ansible -i inventory stapp03 -m shell -a "getfacl /opt/devops/media.txt" --become
```

#### Explanation:  
The `getfacl` command shows ACL settings. We run this to verify correct permissions are applied.

---

## Key Learnings  
- ACL provides fine-grained file permissions  
- `acl` module manages access rules in Ansible  
- Different permissions can be set per user/group  
- `file` module ensures correct ownership  
- Automation simplifies complex permission management 
