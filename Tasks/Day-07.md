# Day 07 – Linux SSH Automation

---

## Task Overview  
The system admins team of `xFusionCorp Industries` has set up some scripts on the `jump host` that run on regular intervals and perform operations on all app servers in `Stratos Datacenter`. To make these scripts work properly we need to make sure the `thor` user on jump host has password-less SSH access to all app servers through their respective sudo users (i.e `tony` for app server 1). Based on the requirements, perform the following:

Set up a password-less authentication from user `thor` on jump host to all app servers through their respective sudo users.
  
---

## Step-by-Step Implementation  

### Step 1: Generate SSH Key Pair  
```bash
ssh-keygen
```
#### Explanation:  
The `ssh-keygen` command is used to generate a public and private key pair for secure authentication.

When this command is executed, it creates two files:
- Private key → `/home/thor/.ssh/id_rsa`
- Public key → `/home/thor/.ssh/id_rsa.pub`

The private key stays on the local system and must be kept secure, while the public key is shared with remote servers.

During execution:
- Press **Enter** to accept default file location  
- Leave passphrase empty for automation (optional)

We run this command to create SSH keys required for password-less authentication.

### Step 2: Copy SSH Key to App Server 1
```bash
ssh-copy-id tony@app-server-1
```
#### Explanation:  
The `ssh-copy-id` command copies the public key to the remote server and configures it for authentication.

This command:
- Connects to the remote server  
- Creates `.ssh` directory if it does not exist  
- Appends the public key to `authorized_keys` file  
- Sets correct permissions automatically  

You will be prompted to enter the password once. After this, SSH login will not require a password.

We run this command to enable password-less SSH access for App Server 1.

---

### Step 3: Copy SSH Key to App Server 2  
```bash
ssh-copy-id steve@app-server-2
```
#### Explanation:  
This command performs the same operation for the second application server using user `steve`.

### Step 4: Copy SSH Key to App Server 3  
```bash
ssh-copy-id banner@app-server-3
```
#### Explanation:  
This command copies the SSH key to App Server 3 using user `banner`.

### Step 5: Verify Password-less SSH  
```bash
ssh tony@app-server-1
ssh steve@app-server-2
ssh banner@app-server-3
```
#### Explanation:  
The `ssh` command is used to connect to remote servers.

After key setup:
- No password should be asked  
- Login should happen directly  

We run these commands to confirm that SSH authentication is working without a password.

---

## Key Learnings  

- SSH keys replace passwords securely  
- ssh-copy-id simplifies setup  
- Password-less SSH enables automation  
- Essential skill for DevOps engineers  
