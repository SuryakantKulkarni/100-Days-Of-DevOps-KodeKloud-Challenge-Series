# Day 22 – Clone a Git Repository on Storage Server

---

## Task Overview  
The DevOps team established a new Git repository last week, which remains unused at present. However, the Nautilus application development team now requires a copy of this repository on the `Storage Server` in the Stratos DC. Follow the provided details to clone the repository:

- The repository to be cloned is located at `/opt/ecommerce.git`.

- Clone this Git repository to the `/usr/src/kodekloudrepos` directory. Perform this task using the `natasha` user, and Ensure no modifications are made to the repository or existing directories, such as changing permissions or making unauthorized alterations.

---

## Step-by-Step Implementation  

### Step 1: Connect to Storage Server  

```bash
ssh natasha@ststor01
```
#### Explanation:  
The `ssh` command is used to securely connect to a remote server over the network. We run this command to access the server where the repository needs to be cloned.

### Step 2: Navigate to Target Directory  

```bash
cd /usr/src/kodekloudrepos
```
#### Explanation:  
The `cd` command changes the current working directory.  
- `/usr/src/kodekloudrepos` is the destination path where repositories are stored  

We run this to ensure the repository is cloned into the correct location.

### Step 3: Clone the Repository  

```bash
git clone /opt/ecommerce.git
```
#### Explanation:  
The `git clone` command creates a complete copy of a repository.  
- `/opt/ecommerce.git` is the source repository path  

This command automatically creates a new directory named `ecommerce`, copies all files and history, and sets up a remote connection.

### Step 4: Verify Clone Operation  

```bash
ls -la
```
#### Explanation:  
The `ls -la` command lists all files and directories with detailed information.  
- `-l` flag shows permissions, ownership, and size  
- `-a` flag includes hidden files  

We run this to confirm that the `ecommerce` directory has been created successfully.

### Step 5: Validate Repository Structure  

```bash
cd ecommerce
git status
```
#### Explanation:  
The `cd ecommerce` command moves into the cloned repository directory.  
The `git status` command shows the current repository state.  

We run this to ensure the repository is correctly cloned and the working tree is clean.

### Step 6: Check Remote Configuration  

```bash
git remote -v
```
#### Explanation:  
The `git remote -v` command displays configured remote repositories. It shows the `origin` pointing to `/opt/ecommerce.git` for both fetch and push operations.  

We run this to verify that the clone is properly linked to the source repository.

## Expected Output  

```
drwxr-xr-x 3 natasha natasha ecommerce
```

---

## Key Learnings  
- `git clone` creates a full copy including history and branches  
- It automatically sets up a remote named `origin`  
- Cloning from local path is faster than network cloning  
- Always verify repository integrity after cloning  
