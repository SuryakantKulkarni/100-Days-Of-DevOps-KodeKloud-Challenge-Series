# Day 33 – Resolve Git Merge Conflicts

---

## Task Overview  
Sarah and Max were working on writing some stories which they have pushed to the repository. Max has recently added some new changes and is trying to push them to the repository but he is facing some issues. Below you can find more details:

- SSH into the `storage server` using user `max` and password `Max_pass123`. Under `/home/max` you will find the `story-blog` repository. Try to push the changes to the origin repo and fix the issues. The `story-index.txt` must have titles for all 4 stories. Additionally, there is a typo in `The Lion and the Mooose` line where `Mooose` should be `Mouse`.

- Click on the `Gitea UI` button on the top bar. You should be able to access the `Gitea` page. You can login to `Gitea` server from UI using username `sarah` and password `Sarah_pass123` or username `max` and password `Max_pass123`.

`Note:` For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.
 
---

## Step-by-Step Implementation  

### Step 1: Connect to Storage Server  
```bash
ssh max@ststor01
```
#### Explanation:  
The `ssh` command connects to the remote storage server. We log in as user `max` to access the repository.

### Step 2: Navigate to Repository  
```bash
cd ~/story-blog
```
#### Explanation:  
The `cd` command changes directory. We move to the Git repository where the conflict exists.

### Step 3: Check Repository Status  
```bash
git status
```
#### Explanation:  
The `git status` command shows current branch state and changes. We run this command to understand the repository condition.

### Step 4: Fix Typo in File  
```bash
vi story-index.txt
```
#### Fix:
```
The Lion and the Mooose → The Lion and the Mouse
```
#### Explanation:  
The `vi` command opens the file for editing. We fix the typo to ensure correct story naming.

### Step 5: Stage Changes  
```bash
git add story-index.txt
```
#### Explanation:  
The `git add` command stages changes. We run this command to prepare the file for commit.

### Step 6: Commit Changes  
```bash
git commit -m "Fix typo in story-index.txt"
```
#### Explanation:  
The `git commit` command saves changes in local repository. We add a message describing the fix.

### Step 7: Attempt Push  
```bash
git push
```
#### Explanation:  
The `git push` command sends changes to remote repository. The push fails because remote has new commits not present locally.

### Step 8: Pull Latest Changes with Rebase  
```bash
git pull --rebase
```
#### Explanation:  
The `git pull --rebase` command fetches remote changes and re-applies local commits on top. We use rebase to maintain a clean commit history.

### Step 9: Identify Merge Conflict  

#### Conflict Example:
```
<<<<<<< HEAD
The Lion and the Mooose
=======
The Lion and the Mouse
>>>>>>> origin/master
```
#### Explanation:  
Git shows conflict markers indicating differences between local and remote changes.

### Step 10: Resolve Conflict  
```bash
vi story-index.txt
```

#### Final Content:
```
1. The Lion and the Mouse
2. The Frogs and the Ox
3. The Fox and the Grapes
4. The Donkey and the Dog
```

#### Explanation:  
We manually remove conflict markers and keep correct content.

We ensure:
- Typo is fixed  
- All 4 stories are present  

### Step 11: Stage Resolved File  
```bash
git add story-index.txt
```
#### Explanation:  
We stage the resolved file to mark conflict as fixed.

### Step 12: Continue Rebase  
```bash
git rebase --continue
```
#### Explanation:  
The `git rebase --continue` command resumes the rebase process.

### Step 13: Push Changes  
```bash
git push
```
#### Explanation:  
We push the updated repository. Now push succeeds because conflicts are resolved.

### Step 14: Verify in Gitea UI  

#### Steps:
- Open Gitea UI  
- Login as `max` or `sarah`  
- Check `story-index.txt`  

#### Explanation:  
We verify changes visually to ensure correctness.

---

### Conflict Markers  

| Marker | Meaning |
|--------|--------|
| `<<<<<<<` | Local changes |
| `=======` | Separator |
| `>>>>>>>` | Remote changes |

---

### Git Workflow  
- Pull → Fix → Add → Continue → Push  

---

## Best Practices  
- Always pull before push  
- Resolve conflicts carefully  
- Use rebase for clean history  
- Verify changes after push  

## Key Learnings  
- Merge conflicts are common in team environments  
- Rebase helps maintain clean commit history  
- Manual conflict resolution is a critical DevOps skill  
- Always verify final output  
