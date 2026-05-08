# Day 92 – Managing Jinja2 Templates Using Ansible

---

## Task Overview  
The Nautilus DevOps team needs to configure an `httpd` role using Ansible and deploy a Jinja2 template on App Server 3.

- Use existing inventory `~/ansible/inventory`  
- Update `~/ansible/playbook.yml` to run httpd role on `stapp03`  
- Create template `index.html.j2`  
- Use `inventory_hostname` variable dynamically  
- Deploy template to `/var/www/html/index.html`  
- Set permissions `0744`  
- Set owner/group as `banner`  

`Note:` Run using `ansible-playbook -i inventory playbook.yml`.

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
