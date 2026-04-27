# Day 27 – Git Revert Changes

---

## Task Overview  
The Nautilus application development team was working on a git repository `/usr/src/kodekloudrepos/official` present on `Storage server` in `Stratos DC`. However, they reported an issue with the recent commits being pushed to this repo. They have asked the DevOps team to revert repo HEAD to last commit. Below are more details about the task:

- In `/usr/src/kodekloudrepos/official` git repository, revert the latest commit `(HEAD)` to the previous commit (JFYI the previous commit hash should be with `initial commit` message).

- Use `revert official` message (please use all small letters for commit message) for the new revert commit.
  
---

## Step-by-Step Implementation  

### Step 1: Connect to Storage Server  

```bash
ssh natasha@ststor01
```
#### Explanation:  
The `ssh` command establishes a secure connection to the remote storage server. We run this to access the server where the repository is located.

### Step 2: Switch to Root User  

```bash
sudo su -
```
#### Explanation:  
The `sudo su -` command switches to root with full administrative privileges.  
- `sudo` provides elevated access  
- `su -` loads root environment  

We run this to ensure we have permission to perform Git operations.

### Step 3: Navigate to Repository  

```bash
cd /usr/src/kodekloudrepos/official
```
#### Explanation:  
The `cd` command changes the working directory to the repository path. We run this so all Git commands are executed inside the correct repository.

### Step 4: Check Commit History  

```bash
git log --oneline
```
#### Explanation:  
The `git log --oneline` command displays commit history in short format.  
- Shows commit hash and message  

We run this to identify the latest commit (HEAD) and confirm the previous commit.

### Step 5: Revert Latest Commit  

```bash
git revert HEAD
```
#### Explanation:  
The `git revert` command creates a new commit that undoes changes from the specified commit.  
- `HEAD` refers to the latest commit  

This opens an editor for commit message; save and exit without changes.

We run this to safely undo changes while preserving history.

### Step 6: Add Required File (if needed)  

```bash
git add official.txt
```
#### Explanation:  
The `git add` command stages the specified file. We run this if any additional file needs to be included in the revert process.

### Step 7: Commit with Required Message  

```bash
git commit -m "revert official"
```
#### Explanation:  
The `git commit` command records changes in repository history.  
- `-m` flag adds a custom commit message  

We run this to ensure the revert commit message matches the requirement.

### Step 8: Verify Revert  

```bash
git log --oneline -3
```
#### Explanation:  
This command shows the latest commits.  

We run this to confirm:
- New revert commit is created  
- Previous commit still exists in history  

---

## Key Learnings  
- `git revert` safely undoes changes without deleting history  
- It creates a new commit instead of modifying existing ones  
- Preferred method for shared repositories  
- Keeps collaboration safe and traceable  
- Avoid using `reset` in shared environments 
