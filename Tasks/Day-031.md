# Day 31 – Git Stash

---

## Task Overview  
The Nautilus application development team was working on a git repository `/usr/src/kodekloudrepos/media` present on `Storage server` in `Stratos DC`. One of the developers stashed some in-progress changes in this repository, but now they want to restore some of the stashed changes. Find below more details to accomplish this task:

Look for the stashed changes under `/usr/src/kodekloudrepos/media` git repository, and restore the stash with `stash@{1}` identifier. Further, commit and push your changes to the origin.

---

## Step-by-Step Implementation  

### Step 1: Connect to Storage Server  

```bash
ssh natasha@ststor01
```
#### Explanation:  
The `ssh` command securely connects to the storage server. We run this to access the repository where stash needs to be restored.

### Step 2: Switch to Root User  

```bash
sudo su -
```
#### Explanation:  
The `sudo su -` command switches to root user with full privileges.  
- `sudo` provides admin access  
- `su -` loads root environment  

We run this because repository is inside system-level directory.

### Step 3: Navigate to Repository  

```bash
cd /usr/src/kodekloudrepos/media
```
#### Explanation:  
The `cd` command changes the working directory to the repository. We run this so all Git operations are performed in the correct project.

### Step 4: List Stashed Changes  

```bash
git stash list
```
#### Explanation:  
The `git stash list` command shows all saved stash entries. 

- `stash@{0}` is most recent  
- `stash@{1}` is older entry  

We run this to identify the required stash to restore.

### Step 5: Apply Specific Stash  

```bash
git stash apply stash@{1}
```
#### Explanation:  
The `git stash apply` command restores changes from a stash.  
- `stash@{1}` specifies which stash to restore  

We use `apply` instead of `pop` so the stash remains saved after applying.

### Step 6: Verify Changes  

```bash
git status
```
#### Explanation:  
The `git status` command shows current repository state.  We run this to confirm restored files (e.g., `welcome.txt`) are ready to commit.

### Step 7: Commit Restored Changes  

```bash
git commit -m "apply stash1"
```
#### Explanation:  
The `git commit` command records restored changes in repository history.  
- `-m` flag adds a commit message  

We run this to permanently save the applied stash changes.

### Step 8: Push Changes to Remote  

```bash
git push origin master
```
#### Explanation:  
The `git push` command uploads local commits to remote repository. We run this so restored changes are shared with the team.

---

## Key Learnings  
- Git stash temporarily saves uncommitted changes  
- `git stash apply` restores without removing stash  
- `git stash pop` restores and removes stash  
- Useful for switching context without losing work  
- Always verify changes before committing 
