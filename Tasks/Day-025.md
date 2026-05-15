# Day 25 – Git Merge Branches

---

## Task Overview  
The Nautilus application development team has been working on a project repository `/opt/media.git`. This repo is cloned at `/usr/src/kodekloudrepos` on `storage server` in `Stratos DC`. They recently shared the following requirements with DevOps team:

Create a new branch `nautilus` in `/usr/src/kodekloudrepos/media` repo from `master` and copy the `/tmp/index.html` file (present on `storage server` itself) into the repo. Further, `add/commit` this file in the new branch and merge back that branch into `master` branch. Finally, push the changes to the origin for both of the branches.

---

## Step-by-Step Implementation  

### Step 1: Connect to Storage Server  

```bash
ssh natasha@ststor01
```
#### Explanation:  
The `ssh` command establishes a secure connection to the remote storage server. We run this to access the server where the Git repository is located.

### Step 2: Switch to Root User  

```bash
sudo su -
```
#### Explanation:  
The `sudo su -` command switches to root with full privileges.  
- `sudo` provides administrative access  
- `su -` loads root environment  

We run this to ensure proper permissions for Git operations.

### Step 3: Navigate to Repository  

```bash
cd /usr/src/kodekloudrepos/media
```
#### Explanation:  
The `cd` command changes the working directory to the repository path. We run this so all Git commands are executed inside the correct repository.

### Step 4: Verify Current Branch  

```bash
git branch
```
#### Explanation:  
The `git branch` command lists all local branches.  
- `*` indicates the current active branch  

We run this to confirm we are on `master` before creating a new branch.

### Step 5: Create and Switch to New Branch  

```bash
git checkout -b nautilus
```
#### Explanation:  
The `git checkout -b` command creates and switches to a new branch.  
- `-b` creates a new branch  
- `nautilus` is the branch name  

We run this to create a separate branch for adding new changes.

### Step 6: Copy File into Repository  

```bash
cp /tmp/index.html .
```
#### Explanation:  
The `cp` command copies files from source to destination.  
- `/tmp/index.html` is the source file  
- `.` represents current directory  

We run this to bring the file into the repository for tracking.

### Step 7: Stage the File  

```bash
git add index.html
```
#### Explanation:  
The `git add` command stages the file for commit. This moves the file from working directory to staging area for version control.

### Step 8: Commit Changes  

```bash
git commit -m "Add index html file for nautilus branch"
```
#### Explanation:  
The `git commit` command saves changes to repository history.  
- `-m` flag allows adding a commit message  

We run this to record the addition of the new file in the branch.

### Step 9: Push New Branch  

```bash
git push origin nautilus
```
#### Explanation:  
The `git push` command uploads local branch to remote repository.  
- `origin` is the remote repository  
- `nautilus` is the branch name  

We run this to make the branch available on the remote server.

### Step 10: Switch Back to Master  

```bash
git checkout master
```
#### Explanation:  
This command switches back to the master branch. We run this because merging must be done from the target branch (master).

### Step 11: Merge Branch into Master  

```bash
git merge nautilus
```
#### Explanation:  
The `git merge` command integrates changes from another branch.  
- `nautilus` is the source branch  

We run this to bring changes from nautilus into master branch.

### Step 12: Push Updated Master  

```bash
git push origin master
```
#### Explanation:  
This command pushes updated master branch to remote repository. We run this so merged changes are available to all team members.

---

## Key Learnings  
- Branching allows safe development without affecting main code  
- `git add` and `commit` track changes in version control  
- `git merge` integrates changes between branches  
- Always push both feature and master branches to remote  
- Fast-forward merge keeps history clean and simple 
