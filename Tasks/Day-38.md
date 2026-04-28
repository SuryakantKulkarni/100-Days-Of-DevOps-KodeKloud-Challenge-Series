# Day 38 – Pull Docker Image & Tag

---

## Task Overview  
Nautilus project developers are planning to start testing on a new project. As per their meeting with the DevOps team, they want to test containerized environment application features. As per details shared with DevOps team, we need to accomplish the following task:

- Pull `busybox:musl` image on `App Server 3` in Stratos DC and re-tag (create new tag) this image as `busybox:news`.
  
---

## Step-by-Step Implementation  

### Step 1: Connect to App Server  

```bash
ssh banner@stapp03
```
#### Explanation:  
The `ssh` command establishes a secure connection to App Server 3. We run this to access the server where Docker operations will be performed.

### Step 2: Pull Docker Image  

```bash
docker pull busybox:musl
```
#### Explanation:  
The `docker pull` command downloads an image from Docker Hub.  
- `busybox` is the image repository  
- `musl` is the tag (version)  

We run this to fetch the required container image locally.

### Step 3: Verify Image Download  

```bash
docker images busybox
```
#### Explanation:  
The `docker images` command lists local images. We run this to confirm that `busybox:musl` is successfully downloaded.

### Step 4: Create New Tag  

```bash
docker tag busybox:musl busybox:news
```
#### Explanation:  
The `docker tag` command creates a new tag for an existing image.  
- Source: `busybox:musl`  
- New tag: `busybox:news`  

This does NOT create a new image; it only creates another reference to the same image ID.

### Step 5: Verify Both Tags  

```bash
docker images busybox
```
#### Explanation:  
This command lists all BusyBox images again. 

We run this to confirm:
- Both `musl` and `news` tags exist  
- Both point to the same IMAGE ID 

---

## Key Learnings  
- `docker pull` downloads images from registry  
- Tags are just labels pointing to same image  
- No extra storage is used when tagging  
- Useful for versioning and environment-based naming  
- Always verify image after pull and tagging  
