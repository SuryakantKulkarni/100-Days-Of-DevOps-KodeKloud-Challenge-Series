# Day 24 – Git Create Branch

---

## Task Overview  
Nautilus developers are actively working on one of the project repositories, `/usr/src/kodekloudrepos/official`. Recently, they decided to implement some new features in the application, and they want to maintain those new changes in a separate branch. Below are the requirements that have been shared with the DevOps team:

- On `Storage server` in Stratos DC create a new branch `xfusioncorp_official` from `master` branch in `/usr/src/kodekloudrepos/official` git repo.

- Please do not try to make any changes in the code.
  
---

## Step-by-Step Implementation  

---

### Step 1: Connect to Storage Server  

```bash
ssh natasha@ststor01
```
#### Explanation:  
The `ssh` command establishes a secure connection to the remote storage server. We run this command to access the server where the repository is located.

### Step 2: Switch to Root User  

```bash
sudo su -
```
#### Explanation:  
The `sudo su -` command switches to the root user with full administrative privileges.  
- `sudo` grants elevated access  
- `su -` loads root environment variables  

We run this to ensure proper permissions for repository operations.

### Step 3: Navigate to Repository  

```bash
cd /usr/src/kodekloudrepos/official
```
#### Explanation:  
The `cd` command changes the current working directory.  
- `/usr/src/kodekloudrepos/official` is the repository path  

We run this to enter the Git repository where branch operations will be performed.

### Step 4: Check Existing Branches  

```bash
git branch -v
```
#### Explanation:  
The `git branch -v` command lists all local branches with commit details.  
- `-v` flag shows the latest commit hash and message  
- `*` indicates the currently active branch  

We run this to verify the current branch and ensure we switch from the correct base.

### Step 5: Switch to Master Branch  

```bash
git checkout master
```
#### Explanation:  
The `git checkout master` command switches the working branch to `master`. This ensures the new branch is created from the correct base branch as required.

### Step 6: Create New Branch  

```bash
git checkout -b xfusioncorp_official
```
#### Explanation:  
The `git checkout -b` command creates and switches to a new branch in one step.  
- `-b` flag tells Git to create a new branch before switching  
- `xfusioncorp_official` is the branch name  

We run this to create a separate branch for new feature development.

### Step 7: Verify New Branch  

```bash
git branch -v
```
#### Explanation:  
This command lists all branches again with commit details. We run this to confirm that the new branch exists and is currently active (`*`).

---

## Key Learnings  
- Git branches allow isolated development without affecting main code  
- `checkout -b` is the fastest way to create and switch branches  
- Branches are lightweight pointers, not full copies of code  
- Always create branches from the correct base (usually master/main)  
