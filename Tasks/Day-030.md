# Day 30 – Git Hard Reset

---

## Task Overview  
The Nautilus application development team was working on a git repository `/usr/src/kodekloudrepos/cluster` present on `Storage server` in `Stratos DC`. This was just a test repository and one of the developers just pushed a couple of changes for testing, but now they want to clean this repository along with the commit history/work tree, so they want to point back the `HEAD` and the branch itself to a commit with message `add data.txt file`. Find below more details:

- In `/usr/src/kodekloudrepos/cluster` git repository, reset the git commit history so that there are only two commits in the commit history i.e `initial commit` and `add data.txt file`.

- Also make sure to push your changes.
  
---

## Step-by-Step Implementation  

### Step 1: Connect to Storage Server  

```bash
ssh natasha@ststor01
```
#### Explanation:  
The `ssh` command connects securely to the remote storage server. We run this to access the repository where changes need to be cleaned.

### Step 2: Switch to Root User  

```bash
sudo su -
```
#### Explanation:  
The `sudo su -` command switches to root user with full privileges.  
- `sudo` grants admin rights  
- `su -` loads root environment  

We run this because the repository is inside a system directory.

### Step 3: Navigate to Repository  

```bash
cd /usr/src/kodekloudrepos/cluster
```
#### Explanation:  
The `cd` command changes the working directory to the repository. We run this so all Git operations target the correct project.

### Step 4: Check Commit History  

```bash
git log --oneline
```
#### Explanation:  
The `git log --oneline` command shows commit history in short format.  

We run this to identify the target commit:
- `add data.txt file`  
- along with multiple unwanted test commits  

### Step 5: Reset to Target Commit  

```bash
git reset --hard 38c46c8
```
#### Explanation:  
The `git reset --hard` command resets:
- HEAD (current pointer)  
- staging area  
- working directory  

- `38c46c8` is the commit hash of **add data.txt file**  

We run this to completely remove all commits after this point.

### Step 6: Push Changes to Remote  

```bash
git push --force
```
#### Explanation:  
The `git push --force` command overwrites remote history.  
- `--force` is required because history has been rewritten  

We run this to sync remote repository with cleaned local history.

### Step 7: Verify Repository State  

```bash
git status
```
#### Explanation:  
The `git status` command checks repository state.  

We run this to confirm:
- Working tree is clean  
- Branch is up to date with origin  

### Step 8: Verify Final Commit History  

```bash
git log --oneline
```
#### Explanation:  
This command shows final commit history.  

We run this to confirm only two commits remain:
- initial commit  
- add data.txt file
  
---

## Key Learnings  
- `git reset --hard` permanently removes commits and changes  
- It resets working directory, staging, and HEAD completely  
- `git push --force` is required after rewriting history  
- Use hard reset carefully in shared repositories  
- Best suited for cleaning test or unwanted commits  
