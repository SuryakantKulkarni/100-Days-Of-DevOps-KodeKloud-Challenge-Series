# Day 82 – Create Ansible Inventory for App Server Testing

---

## Task Overview  
The Nautilus DevOps team is testing Ansible playbooks on various servers within their stack. They've placed some playbooks under `/home/thor/playbook/` directory on the `jump host` and now intend to test them on `app server 2` in `Stratos DC`. However, an inventory file needs creation for Ansible to connect to the respective app. Here are the requirements:

a. Create an ini type Ansible inventory file `/home/thor/playbook/inventory` on `jump host`.

b. Include `App Server 2` in this inventory along with necessary variables for proper functionality.

c. Ensure the inventory hostname corresponds to the `server name` as per the wiki, for example `stapp01` for `app server 1` in `Stratos DC`.

`Note:` Validation will execute the playbook using the command `ansible-playbook -i inventory playbook.yml`. Ensure the playbook functions properly without any extra arguments.

---

## Step-by-Step Implementation  

### Step 1: Navigate to Playbook Directory  

```bash
cd /home/thor/playbook
```
#### Explanation:  
The `cd` command changes the current working directory.  
- `/home/thor/playbook` is the directory where Ansible playbooks are stored  

We run this command to ensure the inventory file is created in the correct location used by Ansible.

### Step 2: List Existing Files  

```bash
ls -la
```
#### Explanation:  
The `ls -la` command lists all files with detailed information.  
- `-l` flag shows permissions, owner, size, and timestamps  
- `-a` flag includes hidden files  

We run this to confirm the directory contents and check that the inventory file does not already exist.

### Step 3: Create Inventory File  

```bash
vi inventory
# or
nano inventory
```
#### Explanation:  
The `vi` or `nano` command opens a text editor to create a file.  
- `inventory` is the standard filename for Ansible inventory  

We run this to create a new file where host and connection details will be defined.

### Step 4: Add Inventory Configuration  

```ini
[app]
stapp02

[app:vars]
ansible_user=steve
ansible_ssh_pass=Am3ric@
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

#### Explanation:  
This defines the inventory structure using INI format.  
- `[app]` creates a group named "app"  
- `stapp02` is the host inside that group  
- `[app:vars]` defines variables applied to all hosts in the group  
- `ansible_user` sets SSH username  
- `ansible_ssh_pass` sets password  
- `ansible_ssh_common_args` disables host key checking  

We run this configuration so Ansible can connect automatically without prompts.

### Step 5: Verify Inventory File  

```bash
cat inventory
```
#### Explanation:  
The `cat` command displays file contents in the terminal. We run this to ensure the inventory file is correctly written with no syntax errors or missing values.

### Step 6: Test Inventory Connectivity  

```bash
ansible -i inventory app -m ping
```
#### Explanation:  
The `ansible` command runs ad-hoc tasks.  
- `-i inventory` specifies inventory file  
- `app` targets the group  
- `-m ping` runs Ansible ping module  

We run this to verify SSH connectivity and ensure Ansible can execute commands on the target host.

### Step 7: Run Playbook Using Inventory  

```bash
ansible-playbook -i inventory playbook.yml
```
#### Explanation:  
The `ansible-playbook` command executes a playbook.  
- `-i inventory` defines the inventory file  
- `playbook.yml` is the automation script  

We run this to execute automation tasks on the defined host.

### Step 8: Validate Inventory Structure  

```bash
ansible-inventory -i inventory --list
```
#### Explanation:  
The `ansible-inventory` command displays inventory details.  
- `--list` shows full structure including variables  

We run this to verify how Ansible interprets the inventory file.

### Step 9: List Hosts in Inventory  

```bash
ansible -i inventory --list-hosts app
```
#### Explanation:  
This command lists all hosts in the specified group. We run this to confirm that `stapp01` is correctly recognized under the app group.

### Step 10: Debug with Verbose Mode  

```bash
ansible -i inventory app -m ping -vvv
```
#### Explanation:  
The `-vvv` flag enables verbose output. This provides detailed logs for SSH connection, authentication, and module execution, which helps in troubleshooting issues.

---

## Key Learnings  
- Inventory defines target systems for Ansible automation  
- Groups help organize servers logically  
- Variables control connection settings  
- Ansible ping verifies connectivity  
- Verbose mode helps debug issues  
