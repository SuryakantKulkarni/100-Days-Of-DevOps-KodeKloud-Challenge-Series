# Day 32 – Git Rebase

---

## Task Overview  
The Nautilus application development team has been working on a project repository `/opt/news.git`. This repo is cloned at `/usr/src/kodekloudrepos` on `storage server` in `Stratos DC`. They recently shared the following requirements with DevOps team:

One of the developers is working on `feature` branch and their work is still in progress, however there are some changes which have been pushed into the `master` branch, the developer now wants to `rebase` the `feature` branch with the `master` branch without loosing any data from the `feature` branch, also they don't want to add any `merge commit` by simply merging the `master` branch into the `feature` branch. Accomplish this task as per requirements mentioned.

Also remember to push your changes once done.

---

## Step-by-Step Implementation  

### Step 1: Connect to Storage Server  

```bash
ssh natasha@ststor01
```
#### Explanation:  
The `ssh` command securely connects to the storage server. We run this to access the repository where rebase is required.

### Step 2: Switch to Root User  

```bash
sudo su -
```
#### Explanation:  
The `sudo su -` command switches to root with full privileges.  
- `sudo` gives admin access  
- `su -` loads root environment  

We run this because repository is inside system-level directory.

### Step 3: Navigate to Repository  

```bash
cd /usr/src/kodekloudrepos/news
```
#### Explanation:  
The `cd` command changes working directory to the repository path. We run this so all Git operations apply to the correct project.

### Step 4: Verify Current Branch  

```bash
git branch
```
#### Explanation:  
The `git branch` command lists available branches.  
- `*` indicates active branch  

We run this to confirm we are on the `feature` branch before rebasing.

### Step 5: Rebase Feature onto Master  

```bash
git rebase master
```
#### Explanation:  
The `git rebase` command reapplies feature branch commits on top of master.  
- `master` is the base branch  

This updates feature branch with latest changes without creating a merge commit.

### Step 6: (Optional) Pull Latest Changes  

```bash
git config pull.rebase true
git pull origin feature
```
#### Explanation:  
- `git config pull.rebase true` ensures future pulls use rebase instead of merge  
- `git pull origin feature` fetches and rebases latest remote changes  

We run this to keep local feature branch fully updated.

### Step 7: Push Updated Branch  

```bash
git push origin feature
```
#### Explanation:  
The `git push` command uploads rebased commits to remote repository. We run this to sync updated feature branch with origin.

### Step 8: Verify Final History  

```bash
git log --oneline --graph
```
#### Explanation:  
This command shows commit history in graphical format.  

We run this to confirm:
- Linear history  
- No merge commits present  

---

## Key Learnings  
- Rebase creates clean linear commit history  
- Avoids unnecessary merge commits  
- Useful for keeping feature branch updated  
- Requires careful handling when pushing changes  
- Preferred for maintaining readable Git history  
