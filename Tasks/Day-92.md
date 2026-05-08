# Day 92 – Managing Jinja2 Templates Using Ansible

---

## Task Overview  
One of the Nautilus DevOps team members is working on to develop a role for `httpd` installation and configuration. Work is almost completed,  however there is a requirement to add a jinja2 template for `index.html` file. Additionally, the relevant task needs to be added inside the role.  The inventory file `~/ansible/inventory` is already present on `jump host` that can be used. Complete the task as per details mentioned below: 

- Update `~/ansible/playbook.yml` playbook to run the `httpd` role on `App Server 3`.

- Create a `jinja2` template `index.html.j2` under `/home/thor/ansible/role/httpd/templates/` directory and add a line `This file was created using Ansible on <respective server>` (for example `This file was created using Ansible on stapp01` in case of `App Server 1`). Also please make sure not to hard code the server name inside the template. Instead, use `inventory_hostname` variable to fetch the correct value.

- Add a task inside `/home/thor/ansible/role/httpd/tasks/main.yml` to copy this template on `App Server 3` under `/var/www/html/index.html`. Also make sure that `/var/www/html/index.html` file's permissions are `0744`.

- The user/group owner of `/var/www/html/index.html` file must be respective sudo user of the server (for example `tony` in case of `stapp01`).

`Note:`  Validation will try to run the playbook using command `ansible-playbook -i inventory playbook.yml` so please make sure the playbook works this way without passing any extra arguments.

---

## Step-by-Step Implementation  

### Step 1: Navigate to Ansible Directory  

```bash
cd /home/thor/ansible
ls -la
```
#### Explanation:  
The `cd` command moves into Ansible working directory.  
The `ls -la` command lists all files and directories with details.  

We run this to verify existing playbook and role structure.

---

## 🔹 Create Role Structure  

### Step 2: Create Required Directories  

```bash
mkdir -p /home/thor/ansible/role/httpd/tasks
mkdir -p /home/thor/ansible/role/httpd/templates
```
#### Explanation:  
The `mkdir -p` command creates nested directories if they do not exist. We create required task and template directories for the Ansible role.

---

## 🔹 Create Jinja2 Template  

### Step 3: Create Template File  

```bash
cat > /home/thor/ansible/role/httpd/templates/index.html.j2 << 'EOF'
This file was created using Ansible on {{ inventory_hostname }}
EOF
```
#### Explanation:  
This command creates the Jinja2 template file.  
- `inventory_hostname` dynamically inserts server hostname  
- No hardcoded server name is used  

We use template variables for reusable automation.

---

## 🔹 Configure Role Tasks  

### Step 4: Create Task File  

```bash
cat > /home/thor/ansible/role/httpd/tasks/main.yml << 'EOF'
---
- name: Install httpd package
  yum:
    name: httpd
    state: present

- name: Start and enable httpd service
  service:
    name: httpd
    state: started
    enabled: yes

- name: Ensure document root exists
  file:
    path: /var/www/html
    state: directory

- name: Deploy index.html template
  template:
    src: index.html.j2
    dest: /var/www/html/index.html
    owner: banner
    group: banner
    mode: '0744'
EOF
```
#### Explanation:  
This command creates role tasks.  
- `yum` installs httpd package  
- `service` starts and enables service  
- `file` ensures document root exists  
- `template` copies rendered Jinja2 file  

We use the template module for dynamic file generation.

---

## 🔹 Configure Playbook  

### Step 5: Update Playbook File  

```bash
cat > /home/thor/ansible/playbook.yml << 'EOF'
---
- name: Run httpd role on App Server 3
  hosts: stapp03
  become: yes

  tasks:
    - import_tasks: /home/thor/ansible/role/httpd/tasks/main.yml
EOF
```
#### Explanation:  
This command updates playbook file.  
- `hosts: stapp03` targets App Server 3  
- `become: yes` enables sudo privileges  
- `import_tasks` loads task file  

We use this to execute role tasks on the target server.

### Step 6: Verify Configuration Files  

```bash
cat /home/thor/ansible/playbook.yml
cat /home/thor/ansible/role/httpd/tasks/main.yml
cat /home/thor/ansible/role/httpd/templates/index.html.j2
```
#### Explanation:  
Displays playbook, task, and template files. We run this to confirm correct configuration before execution.

---

## 🔹 Testing and Execution  

### Step 7: Run Playbook  

```bash
cd /home/thor/ansible

ansible-playbook -i inventory playbook.yml
```
#### Explanation:  
The `ansible-playbook` command executes automation tasks. We run this to install httpd and deploy template file.

### Step 8: Verify Template Deployment  

```bash
ansible -i inventory stapp03 -a "cat /var/www/html/index.html"

ansible -i inventory stapp03 -a "ls -l /var/www/html/index.html"
```
#### Explanation:  
- First command checks webpage content  
- Second verifies permissions and ownership  

We run this to confirm successful deployment.

### Expected Output  

```bash
This file was created using Ansible on stapp03
```

```bash
-rwxr--r-- 1 banner banner
```

---

## Key Learnings  
- Jinja2 templates allow dynamic configuration files  
- `inventory_hostname` provides target server hostname  
- `template` module renders variables automatically  
- Roles organize Ansible tasks efficiently  
- Automation improves consistency and scalability  

---

🚀 **Day 92 Complete – Managing Jinja2 Templates Using Ansible**
````
