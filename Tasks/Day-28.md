# Day 28 – Git Cherry Pick

---

## Task Overview  
The Nautilus application development team has been working on a project repository `/opt/cluster.git`. This repo is cloned at `/usr/src/kodekloudrepos` on `storage server` in `Stratos DC`. They recently shared the following requirements with the DevOps team:

There are two branches in this repository, `master` and `feature`. One of the developers is working on the `feature` branch and their work is still in progress, however they want to merge one of the commits from the `feature` branch to the `master` branch, the message for the commit that needs to be merged into `master` is `Update info.txt`. Accomplish this task for them, also remember to push your changes eventually.

---

## Step-by-Step Implementation  

### Step 1: Connect to Storage Server  

```bash
ssh natasha@ststor01
```
#### Explanation:  
The `ssh` command is used to securely connect to the remote storage server. We run this to access the server where the repository is located.

### Step 2: Switch to Root User  

```bash
sudo su -
```
#### Explanation:  
The `sudo su -` command switches to root with full administrative privileges.  
- `sudo` provides elevated access  
- `su -` loads root environment  

We run this to ensure proper permissions for Git operations.

### Step 3: Navigate to Repository  

```bash
cd /usr/src/kodekloudrepos/cluster
```
#### Explanation:  
The `cd` command changes the working directory to the repository location. We run this so all Git commands are executed inside the correct project.

### Step 4: Check Available Branches  

```bash
git branch
```
#### Explanation:  
The `git branch` command lists all local branches.  
- `*` indicates the current active branch  

We run this to confirm that both `feature` and `master` branches exist.

### Step 5: View Commit History  

```bash
git log --oneline
```
#### Explanation:  
The `git log --oneline` command shows commit history in short format. It helps identify the commit with message **"Update info.txt"** and its hash.

### Step 6: Switch to Master Branch  

```bash
git checkout master
```
#### Explanation:  
The `git checkout master` command switches to the master branch. We run this because cherry-pick applies commits to the currently active branch.

### Step 7: Apply Cherry-Pick  

```bash
git cherry-pick 631b741
```
#### Explanation:  
The `git cherry-pick` command applies changes from a specific commit.  
- `631b741` is the commit hash of **"Update info.txt"**  

This creates a new commit on master with the same changes but a new commit ID.

### Step 8: Verify Changes  

```bash
git log --oneline -3
```
#### Explanation:  
This command displays recent commits. We run this to confirm that the cherry-picked commit appears in master history.

### Step 9: Push Changes to Remote  

```bash
git push
```
#### Explanation:  
The `git push` command uploads local changes to the remote repository. We run this to ensure the updated master branch is available to the team.

### Step 10: Verify Files  

```bash
ls
```
#### Explanation:  
The `ls` command lists files in the repository.  We run this to confirm that `info.txt` exists after cherry-pick operation.

---

## Key Learnings  
- `Cherry-pick` applies specific commits without merging full branch  
- It creates a new commit with same changes but different hash  
- Useful for hotfixes and selective feature transfer  
- Helps avoid merging incomplete work  
- Always verify commit before applying  
