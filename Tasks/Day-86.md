# Day 86 – Ansible Ping Module Usage

---

## Task Overview  
The Nautilus DevOps team is planning to test several Ansible playbooks on different app servers in `Stratos DC`. Before that, some pre-requisites must be met. Essentially, the team needs to set up a password-less SSH connection between Ansible controller and Ansible managed nodes. One of the tickets is assigned to you; please complete the task as per details mentioned below: 

- `Jump host` is our Ansible controller, and we are going to run Ansible playbooks through `thor` user from `jump host`.

- There is an inventory file `/home/thor/ansible/inventory` on `jump host`. Using that inventory file test `Ansible ping` from `jump host` to `App Server 2`, make sure ping works.

---

## Step-by-Step Implementation  

### Step 1: Check Inventory File  

```bash
cat /home/thor/ansible/inventory
```
#### Explanation:  
The `cat` command displays the inventory file content. We run this to verify if `stapp02` is already present or needs to be added.

---

## 🔹 Configure Inventory  

### Step 2: Update Inventory (if required)  

```bash
cat > /home/thor/ansible/inventory << 'EOF'
[app]
stapp02 ansible_user=steve ansible_ssh_pass=Am3ric@

[app:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF
```
#### Explanation:  
This command creates or updates the inventory file.  
- `stapp02` is target server  
- `ansible_user` defines login user  
- `ansible_ssh_pass` sets password  

We use this to ensure Ansible can initially connect to the server.

---

## 🔹 Setup Passwordless SSH  

### Step 3: Generate SSH Key  

```bash
ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
```
#### Explanation:  
The `ssh-keygen` command generates SSH key pair.  
- `-t rsa` specifies key type  
- `-f` defines file path  
- `-N ""` sets empty passphrase  

We run this to enable secure passwordless login.

### Step 4: Copy SSH Key to Server  

```bash
ssh-copy-id -o StrictHostKeyChecking=no steve@stapp02
```
#### Explanation:  
The `ssh-copy-id` command copies public key to remote server. We run this so the jump host can login without password.

### Step 5: Verify Passwordless SSH  

```bash
ssh -o StrictHostKeyChecking=no steve@stapp02 "echo connected"
```
#### Explanation:  
This command tests SSH login. We run this to confirm no password prompt appears.

---

## 🔹 Update Inventory  

### Step 6: Remove Password from Inventory  

```bash
cat > /home/thor/ansible/inventory << 'EOF'
[app]
stapp02 ansible_user=steve

[app:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF
```
#### Explanation:  
This updates inventory to use SSH key authentication. We remove password since passwordless SSH is now configured.

---

## 🔹 Testing  

### Step 7: Run Ansible Ping  

```bash
cd /home/thor/ansible
ansible -i inventory app -m ping
```
#### Explanation:  
The `ansible` command runs ping module.  
- `-m ping` checks connectivity  

We run this to confirm Ansible can connect successfully.

---

## Key Learnings  
- SSH keys enable passwordless authentication  
- Inventory defines connection method  
- `ssh-copy-id` simplifies key distribution  
- Removing passwords improves security  
- `ping` module validates Ansible connectivity
