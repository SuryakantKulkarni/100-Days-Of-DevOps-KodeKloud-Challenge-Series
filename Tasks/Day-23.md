# Day 23 – Fork a Git Repository

---

## Task Overview  
There is a Git server utilized by the Nautilus project teams. Recently, a new developer named Jon joined the team and needs to begin working on a project. To begin, he must fork an existing Git repository. Follow the steps below:

- Click on the `Gitea UI` button located on the top bar to access the Gitea page.

- Login to `Gitea` server using username `jon` and password `Jon_pass123`.

- Once logged in, locate the Git repository named `sarah/story-blog` and `fork` it under the `jon` user.
---

## Step-by-Step Implementation  

### Step 1: Open Gitea UI  

- Click on the **Gitea UI** button from the top bar  

#### Explanation:  
Gitea is a web-based Git hosting platform similar to GitHub or GitLab. We open this interface to perform repository operations like forking using a graphical UI.

### Step 2: Login to Gitea  

| Field | Value |
|------|------|
| Username | jon |
| Password | Jon_pass123 |

#### Explanation:  
Login is required to access repositories and perform actions under your account. We use Jon’s credentials because the fork must be created under his user profile.

### Step 3: Locate Repository  

- Navigate to: **sarah/story-blog**

#### Explanation:  
This repository belongs to user `sarah` and is named `story-blog`. We open this repository because it is the source project that needs to be forked.

### Step 4: Click Fork Button  

- Click **Fork** (top-right corner)

#### Explanation:  
The Fork button creates a server-side copy of the repository under your account. This allows you to make changes independently without affecting the original repository.

### Step 5: Confirm Fork Creation  

After forking, verify:

- Repository path becomes: **jon/story-blog**  
- Shows: **forked from sarah/story-blog**  
- All files and branches are present  

#### Explanation:  
This confirms that the fork was created successfully and linked to the original repository. The fork maintains a relationship with the source repo, allowing future contributions.

---

## Key Learnings  
- Fork creates a personal copy of a repository on the server  
- It allows independent development without affecting the original project  
- Fork maintains a link to the upstream repository  
- It is commonly used in open-source and team collaboration workflows  
