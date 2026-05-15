# Day 21 – Setup Git Repository on Storage Server

---

## Task Overview  
The Nautilus development team has provided requirements to the DevOps team for a new application development project, specifically requesting the establishment of a Git repository. Follow the instructions below to create the Git repository on the `Storage server` in the Stratos DC:

- Utilize `yum` to install the `git` package on the `Storage Server`.

- Create a bare repository named /opt/demo.git (ensure exact name usage).

---

## Step-by-Step Implementation  

### Step 1: Connect to Storage Server  

```bash
ssh natasha@ststor01
```
#### Explanation:  
The `ssh` command is used to securely connect to a remote server. We run this command to access the server where the Git repository will be created.

### Step 2: Switch to Root User  

```bash
sudo su -
```
#### Explanation:  
The `sudo su -` command switches to the root user with full administrative privileges.  
- `sudo` provides elevated access  
- `su -` loads root environment variables  

We run this to install packages and create directories in system-level paths like `/opt`.

### Step 3: Install Git  

```bash
dnf install git -y
```
#### Explanation:  
The `dnf install` command installs packages from repositories.  
- `git` is the version control system package  
- `-y` flag automatically confirms installation prompts  

We run this to install Git, which will manage version control for the project.

### Step 4: Create Bare Repository  

```bash
git init --bare /opt/demo.git
```
#### Explanation:  
The `git init` command initializes a new Git repository.  
- `--bare` creates a repository without a working directory  
- `/opt/demo.git` is the repository path and name  

We run this to create a central repository that developers can push to and pull from.

### Step 5: Verify Repository Creation  

```bash
ls -la /opt/
```
#### Explanation:  
The `ls -la` command lists files with detailed information.  
- `-l` flag shows permissions, ownership, and size  
- `-a` flag includes hidden files  

We run this to confirm that the `demo.git` directory has been successfully created.

## Expected Output  

```
drwxr-xr-x 7 root root 4096 demo.git
```

---

## Key Learnings  
- Bare repositories are used as central repositories for collaboration  
- They do not contain working files, only Git data  
- Git enables version control, branching, and team collaboration  
- `/opt` is commonly used for hosting shared repositories  
