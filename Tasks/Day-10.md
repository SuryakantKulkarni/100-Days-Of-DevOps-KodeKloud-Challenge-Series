# Day 10 – Linux Bash Scripts

---

## Task Overview
The production support team of `xFusionCorp Industries` is working on developing some bash scripts to automate different day to day tasks. One is to create a bash script for taking websites backup. They have a static website running on `App Server 1` in `Stratos Datacenter`, and they need to create a bash script named `media_backup.sh` which should accomplish the following tasks. (Also remember to place the script under `/scripts` directory on `App Server 1`).

- Create a zip archive named `xfusioncorp_media.zip` of `/var/www/html/media` directory.
  
- Save the archive in `/backup/` on `App Server 1`. This is a temporary storage, as backups from this location will be clean on weekly basis. Therefore, we also need to save this backup archive on `Nautilus Backup Server`.

- Copy the created archive to `Nautilus Backup Server` server in `/backup/` location.

- Please make sure script won't ask for **password** while copying the archive file. Additionally, the respective server user (for example, `steve` in case of `App Server 2`) must be able to run it.

---

## Step-by-Step Implementation  

### Step 1: Setup SSH Key-Based Authentication  
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```

#### Explanation:  
The `ssh-keygen` command generates a public and private SSH key pair.
- `-t rsa` specifies RSA algorithm
- `-b 4096` sets strong encryption key size.
- `-f ~/.ssh/id_rsa` defines file location
- `-N ""` creates key without passphrase for automation.

We run this command to enable secure password-less authentication between servers.

### Step 2: Copy Public Key to Backup Server  
```bash
ssh-copy-id clint@stbkp01
```
#### Explanation:  
The `ssh-copy-id` command copies the public key to the remote server. It adds the key into `authorized_keys` file and sets correct permissions. After this, SSH login will not require password.

We run this command to allow automated file transfer without manual password input.

### Step 3: Create Script Directory  
```bash
sudo mkdir -p /scripts
```
#### Explanation:  
The `mkdir` command creates directories.
- `-p` flag ensures directory is created even if parent directories do not exist and avoids errors if it already exists.

We run this command to store automation scripts in a standard location.

### Step 4: Create Backup Script  
```bash
sudo vi /scripts/beta_backup.sh
```
#### Script Content:
```bash
#!/bin/sh

zip -r /backup/xfusioncorp_beta.zip /var/www/html/beta
scp /backup/xfusioncorp_beta.zip clint@stbkp01:/backup/
```

#### Explanation:  
The `vi` command opens the file editor to create script.

The first line `#!/bin/sh` is called shebang and defines the shell interpreter.

The `zip -r` command creates a compressed archive of the directory recursively.

The `scp` command securely copies the backup file to remote server using SSH.

We run this step to automate backup creation and transfer process.

### Step 5: Make Script Executable  
```bash
sudo chmod +x /scripts/beta_backup.sh
```
#### Explanation:  
The `chmod +x` command adds execute permission to the script. Without this permission, the script cannot be executed.

We run this command to allow users to run the script directly.

### Step 6: Verify Script Permissions  
```bash
ls -l /scripts/beta_backup.sh
```
#### Explanation:  
The `ls -l` command displays file permissions. The output should show `-rwxr-xr-x`, where `x` means executable.

We run this command to confirm script is executable.

### Step 7: Execute the Script  
```bash
sudo /scripts/beta_backup.sh
```
#### Explanation:  
This command runs the backup script.

It performs two operations:
- Creates zip backup  
- Transfers file to backup server  

We run this command to test automation.

### Step 8: Verify Local Backup  
```bash
ls -lh /backup/xfusioncorp_beta.zip
```
#### Explanation:  
The `ls -lh` command shows file details with readable size. We run this command to confirm backup file is created locally.

### Step 9: Verify Remote Backup  
```bash
ssh clint@stbkp01 "ls -lh /backup/xfusioncorp_beta.zip"
```
#### Explanation:  
This command connects to remote server and checks if file exists. The command inside quotes runs on remote server.

We run this command to verify successful file transfer.

### Step 10: Test Without Root  
```bash
/scripts/beta_backup.sh
```
#### Explanation:  
This command runs script without sudo. We run this to ensure script works for normal users and automation systems.

---

## Best Practices  
- Always use SSH keys for automation  
- Store scripts in standard directory  
- Test scripts before production use  
- Keep backups in multiple locations  

## Key Learnings  
- Bash scripts automate system tasks  
- SSH keys are required for automation  
- File transfer can be secured using SCP  
- Backup strategies are critical in DevOps  
