# Day 26 – Git Manage Remotes

---

## Task Overview  
The xFusionCorp development team added updates to the project that is maintained under `/opt/ecommerce.git` repo and cloned under `/usr/src/kodekloudrepos/ecommerce`. Recently some changes were made on Git server that is hosted on `Storage server` in `Stratos DC`. The DevOps team added some new Git remotes, so we need to update remote on `/usr/src/kodekloudrepos/ecommerce` repository as per details mentioned below:

- In `/usr/src/kodekloudrepos/ecommerce` repo add a new remote `dev_ecommerce` and point it to `/opt/xfusioncorp_ecommerce.git` repository.

- There is a file `/tmp/index.html` on same server; copy this file to the repo and add/commit to master branch.

- Finally push `master branch to this new remote origin.
  
---

## Step-by-Step Implementation  

### Step 1: Connect to Storage Server  

```bash
ssh natasha@ststor01
```
#### Explanation:  
The `ssh` command is used to securely connect to the remote storage server. We run this to access the server where the Git repository exists.

### Step 2: Switch to Root User  

```bash
sudo su -
```
#### Explanation:  
The `sudo su -` command switches to the root user with full privileges.  
- `sudo` provides administrative access  
- `su -` loads root environment variables  

We run this to ensure we have proper permissions to modify the repository.

### Step 3: Navigate to Repository  

```bash
cd /usr/src/kodekloudrepos/ecommerce
```
#### Explanation:  
The `cd` command changes the working directory to the repository location.  We run this so all Git operations are performed inside the correct project.

### Step 4: Check Current Branch  

```bash
git branch
```
#### Explanation:  
The `git branch` command lists all local branches.  
- `*` indicates the active branch  

We run this to confirm we are on the `master` branch before making changes.

### Step 5: Add New Remote  

```bash
git remote add dev_ecommerce /opt/xfusioncorp_ecommerce.git
```
#### Explanation:  
The `git remote add` command creates a new remote reference.  
- `dev_ecommerce` is the remote name  
- `/opt/xfusioncorp_ecommerce.git` is the remote repository path  

We run this to link our local repo to a new remote destination.

### Step 6: Verify Remote  

```bash
git remote -v
```
#### Explanation:  
The `git remote -v` command shows all configured remotes with URLs. We run this to confirm the new remote was added successfully alongside `origin`.

### Step 7: Copy File into Repository  

```bash
cp /tmp/index.html .
```
#### Explanation:  
The `cp` command copies the file into the current directory.  
- `/tmp/index.html` is the source  
- `.` represents the current repository directory  

We run this to add new content that will be tracked by Git.

### Step 8: Check Repository Status  

```bash
git status
```
#### Explanation:  
The `git status` command shows the current state of files.  It displays untracked files (in red) that are not yet added to version control.

### Step 9: Stage the File  

```bash
git add index.html
```
#### Explanation:  
The `git add` command stages the file for commit. This moves the file from working directory to staging area for tracking changes.

### Step 10: Commit Changes  

```bash
git commit -m "updated index.html"
```
#### Explanation:  
The `git commit` command records the staged changes in repository history.  
- `-m` flag adds a commit message describing the change  

We run this to save the file into version control.

### Step 11: Push to New Remote  

```bash
git push -u dev_ecommerce master
```
#### Explanation:  
The `git push` command uploads changes to a remote repository.  
- `-u` flag sets upstream tracking  
- `dev_ecommerce` is the remote name  
- `master` is the branch  

We run this to push the master branch to the new remote and link it for future pushes.

---

## Key Learnings  
- Git remotes act as connections to external repositories  
- Multiple remotes can exist for backup, deployment, or collaboration  
- `git remote add` links a new repository  
- `git push -u` sets upstream tracking for easier future commands  
- Always verify changes using `git status` before committing  
