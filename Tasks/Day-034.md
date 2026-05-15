# Day 34 – Git Hooks (Post-Update Automation)

---

## Task Overview  
The Nautilus application development team was working on a git repository `/opt/media.git` which is cloned under `/usr/src/kodekloudrepos` directory present on `Storage server` in `Stratos DC`. The team want to setup a hook on this repository, please find below more details:

- Merge the `feature` branch into the `master` branch, but before pushing your changes complete below point.

- Create a `post-update` hook in this git repository so that whenever any changes are pushed to the `master` branch, it creates a release tag with name `release-2023-06-15`, where `2023-06-15` is supposed to be the current date. For example if today is `20th June, 2023` then the release tag must be `release-2023-06-20`. Make sure you test the hook at least once and create a release tag for today's release.

- Finally remember to push your changes.

`Note:` Perform this task using the `natasha` user, and ensure the repository or existing directory permissions are not altered. 

---

## Step-by-Step Implementation  

### Step 1: Connect to Storage Server  
```bash
ssh natasha@ststor01
sudo -i
```
#### Explanation:  
The `ssh` command connects to the storage server. The `sudo -i` command switches to root user.

We run this command to get administrative access required for Git repository changes.

### Step 2: Navigate to Repository  
```bash
cd /usr/src/kodekloudrepos/demo
```
#### Explanation:  
The `cd` command changes directory.

We move to the working repository where code changes are performed.

### Step 3: Check Branches  
```bash
git branch
```
#### Explanation:  
The `git branch` command lists all branches.

We run this command to confirm that `feature` and `master` branches exist.

### Step 4: Switch to Master Branch  
```bash
git checkout master
```
#### Explanation:  
The `git checkout` command switches branches.

We switch to `master` because the merge will happen into this branch.

### Step 5: Merge Feature Branch  
```bash
git merge feature
```
#### Explanation:  
The `git merge` command combines changes from `feature` into `master`.

We run this command to integrate new features into the main branch.

### Step 6: Create Post-Update Hook  
```bash
cp /opt/demo.git/hooks/post-update.sample /opt/demo.git/hooks/post-update
```
#### Explanation:  
This command copies the sample hook file. Git hooks only work when the `.sample` extension is removed.

We run this command to activate the hook file.

### Step 7: Make Hook Executable  
```bash
chmod +x /opt/demo.git/hooks/post-update
```
#### Explanation:  
The `chmod +x` command gives execute permission. Git only runs hooks that are executable.

### Step 8: Edit Hook File  
```bash
vi /opt/demo.git/hooks/post-update
```
#### Add Script:
```bash
#!/bin/bash

cd /opt/demo.git
tag=release-$(date "+%Y-%m-%d")
git tag $tag
```
#### Explanation:  
The script uses `date` command to generate current date.
- `tag=release-$(date ...)` creates dynamic tag name.
- `git tag $tag` creates a new tag.

We run this script to automate release tagging.

### Step 9: Push Changes  
```bash
git push origin master
```
#### Explanation:  
The `git push` command sends changes to remote repository. This action triggers the post-update hook.

### Step 10: Fetch Tags  
```bash
git fetch --tags
```
#### Explanation:  
The `git fetch --tags` command downloads tags from remote.

We run this command to sync newly created tags.

### Step 11: Verify Tags  
```bash
git tag
```
#### Explanation:  
The `git tag` command lists all tags.

We run this command to confirm tag creation like:
```
release-2026-04-13
```

### Step 12: (Optional) View Tag Details  
```bash
git show <tag-name>
```
#### Explanation:  
The `git show` command displays tag details and commit info.

We run this command to verify the tag is correctly created.

---

## Best Practices  
- Always test hooks before production  
- Use dynamic naming for tags  
- Keep hooks simple and efficient  
- Use annotated tags in real projects  

## Key Learnings  

- Git hooks automate workflows  
- Post-update hooks run after push  
- Tags help in version management  
- Automation reduces manual effort  
