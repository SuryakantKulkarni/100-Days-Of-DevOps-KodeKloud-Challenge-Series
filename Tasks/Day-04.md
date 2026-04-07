# Day 04 – Script Execution Permissions

---

## Task Overview  
In a bid to automate backup processes, the `xFusionCorp Industries` sysadmin team has developed a new bash script named `xfusioncorp.sh`. While the script has been distributed to all necessary servers, it lacks executable permissions on `App Server 1` within the Stratos Datacenter.

Your task is to grant executable permissions to the `/tmp/xfusioncorp.sh` script on `App Server 1`. Additionally, ensure that all users have the capability to execute it.

---

## Step-by-Step Implementation  

### Step 1: Connect to Server and Switch to Root User 
```bash
ssh tony@stapp01.stratos.xfusioncorp.com
```
#### Explanation:
The `ssh` command is used to connect to a remote server securely.

### Step 2: Check Current Permissions
```bash
ls -lah /tmp/xfusioncorp.sh
```
#### Explanation:
The `ls -lah` command shows file permissions and details. We run this to verify that the script does not have execute permission.

### Step 3: Add Execute Permission
```bash
sudo chmod a+rx /tmp/xfusioncorp.sh
```
#### Explanation:
The `chmod` command is used to change file permissions.
- `a` → all users (owner, group, others)
- `+r` → add read permission
- `+x` → add execute permission
We run this to allow all users to read and execute the script.

### Step 4: Verify Updated Permissions
```bash
ls -lah /tmp/xfusioncorp.sh
```
#### Explanation:
We run this again to confirm that permissions are updated correctly.

Expected output:
```bash
-r-xr-xr-x
```

---

## Key Concepts

### File Permissions
- `r` (read) → view file content
- `w` (write) → modify file
- `x` (execute) → run file as program
  
### Permission Categories
- `u` (User) → file owner
- `g` (Group) → group members
- `o` (Others) → all other users

### chmod Modes
**Symbolic Mode** uses characters and operators to add, remove, or set specific permissions. 
- `chmod a+rx file` → add permissions
- `+` → add permission
- `-` → remove permission
- `=` → set exact permission
  
**Numeric (Octal) Method** uses a three-digit (or four-digit) number to set permissions for three user categories:
- `r = 4`, `w = 2`, `x = 1`
- Example:
  - 755 → rwxr-xr-x
  - 644 → rw-r--r--
  
### Common Permission Patterns
- 755 → executable file
- 644 → normal file
- 600 → private file
- 777 → full access (not recommended)

---

## Security Best Practices
- Follow least privilege principle
- Avoid giving unnecessary permissions
- Do not use 777 in production
- Only grant execute permission when needed

## Key Learnings
- File permissions are critical for system security
- chmod is used to control access
- Execute permission is required for scripts
- Proper permissions prevent misuse of files
- Always follow least privilege principle

---

Next Challenge: [Day 05 →](Tasks/Day-05.md) 
