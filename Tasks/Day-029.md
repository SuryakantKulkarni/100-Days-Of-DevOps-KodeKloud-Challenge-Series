# Day 29 – Manage Git Pull Requests

---

## Task Overview  
`Max` want to push some new changes to one of the repositories but we don't want people to push directly to `master` branch, since that would be the final version of the code. It should always only have content that has been reviewed and approved. We cannot just allow everyone to directly push to the master branch. So, let's do it the right way as discussed below:

SSH into `storage server` using user `max`, password `Max_pass123`. There you can find an already cloned repo under `Max` user's home. 

Max has written his story about `The 🦊 Fox and Grapes 🍇`.

Max has already pushed his story to remote git repository hosted on `Gitea` branch `story/fox-and-grapes`.

Check the contents of the cloned repository. Confirm that you can see Sarah's story and history of commits by running `git log` and validate author info, commit message etc.

Max has pushed his story, but his story is still not in the `master` branch. Let's create a Pull Request(PR) to merge Max's `story/fox-and-grapes` branch into the `master branch.

Click on the `Gitea UI` button on the top bar. You should be able to access the `Gitea` page.

**UI login info:**

- Username: `max`

- Password: `Max_pass123`

- PR title : `Added fox-and-grapes story`

- PR pull from branch: `story/fox-and-grapes` (source)

- PR merge into branch: `master` (destination)

Before we can add our story to the `master` branch, it has to be reviewed. So, let's ask `tom` to review our PR by assigning him as a reviewer.

Add `tom` as reviewer through the Git Portal UI.

- Go to the newly created PR

- Click on Reviewers on the right

- Add tom as a reviewer to the PR

Now let's review and approve the PR as user `Tom`. 

Login to the portal with the user `tom`.

Logout of `Git Portal UI` if logged in as `max`.

**UI login info:**

- Username: `tom`

- Password: `Tom_pass123`

- PR title : `Added fox-and-grapes story`

Review and merge it.

Great stuff!! The story has been merged! 👏

---

## Step-by-Step Implementation  

### Step 1: Connect to Storage Server  

```bash
ssh max@ststor01
```
#### Explanation:  
The `ssh` command establishes a secure connection to the storage server. We run this to access the repository where Max has already pushed his changes.

### Step 2: Navigate to Repository  

```bash
cd ~/story-blog
```
#### Explanation:  
The `cd` command changes the working directory to the cloned repository. We run this to inspect repository contents and verify branch status.

### Step 3: Verify Files  

```bash
ls
```
#### Explanation:  
The `ls` command lists files in the repository directory. We run this to confirm that Max’s file exists in the feature branch.

### Step 4: Check Commit History  

```bash
git log --oneline
```
#### Explanation:  
The `git log --oneline` command displays commit history in short format. We run this to verify author details, commit messages, and Max’s new commit.

### Step 5: Check Available Branches  

```bash
git branch
```
#### Explanation:  
The `git branch` command lists all local branches. 

We run this to confirm the presence of:
- `master`
- `story/fox-and-grapes` (feature branch)

### Step 6: Verify Master Branch Content  

```bash
git checkout master
ls
```
#### Explanation:  
The `git checkout master` command switches to master branch. We run this to confirm that Max’s changes are NOT yet merged into master.

---

## 🔹 Create Pull Request (Gitea UI)  

### Step 7: Login to Gitea  

| Field | Value |
|------|------|
| Username | max |
| Password | Max_pass123 |

#### Explanation:  
Login to Gitea web interface to manage repositories and create PR. We run this step because pull requests are handled through the UI.

### Step 8: Create Pull Request  

| Field | Value |
|------|------|
| Title | Added fox-and-grapes story |
| Source Branch | story/fox-and-grapes |
| Target Branch | master |

#### Explanation:  
A Pull Request proposes merging changes from one branch to another. We create this to move Max’s changes into master after review.

### Step 9: Add Reviewer  

| Field | Value |
|------|------|
| Reviewer | tom |

#### Explanation:  
Assigning a reviewer ensures code is checked before merging. We add Tom so he can review and approve the changes.

---

## 🔹 Review and Merge  

### Step 10: Login as Reviewer  

| Field | Value |
|------|------|
| Username | tom |
| Password | Tom_pass123 |

#### Explanation:  
Login as Tom to perform code review. We run this step because only reviewers can approve and merge PR.

### Step 11: Review Pull Request  

- Open PR: **Added fox-and-grapes story**  
- Check changes under "Files Changed"

#### Explanation:  
Reviewing ensures code quality, correctness, and completeness. We run this to validate Max’s changes before merging.

### Step 12: Approve and Merge  

- Click **Approve**  
- Click **Merge Pull Request**

#### Explanation:  
Approval confirms changes are valid. Merge integrates feature branch into master branch permanently.

---

## 🔹 Verification  

### Step 13: Verify Changes in Master  

```bash
git pull origin master
git log --oneline
```
#### Explanation:  
The `git pull` command fetches latest changes from remote. We run this to confirm that Max’s commit is now part of master branch.

---

## Key Learnings  
- Pull Requests enforce code review before merging  
- Prevent direct changes to master branch  
- Improve collaboration and code quality  
- Provide audit trail of changes and approvals  
- Essential workflow in real DevOps environments 
