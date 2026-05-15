# Day 39 – Create Docker Image from Container

---

## Task Overview  
One of the Nautilus developer was working to test new changes on a container. He wants to keep a backup of his changes to the container. A new request has been raised for the DevOps team to create a new image from this container. Below are more details about it:

- Create an image `ecommerce:nautilus` on `Application Server 3` from a container `ubuntu_latest` that is running on same server.

---

## Step-by-Step Implementation  

### Step 1: Connect to App Server  

```bash
ssh banner@stapp03
```
#### Explanation:  
The `ssh` command connects securely to App Server 3. We run this to access the Docker environment where the container is running.

### Step 2: Check Existing Images  

```bash
docker images
```
#### Explanation:  
The `docker images` command lists all locally available images. We run this to confirm the base image `(ubuntu:latest)` exists before creating a new one.

### Step 3: Verify Running Container  

```bash
docker ps
```
#### Explanation:  
The `docker ps` command lists all running containers. We run this to confirm that the container `ubuntu_latest` is running.

### Step 4: Create Image from Container  

```bash
docker commit ubuntu_latest ecommerce:nautilus
```
#### Explanation:  
The `docker commit` command creates a new image from a container.  
- `ubuntu_latest` → source container  
- `ecommerce:nautilus` → new image name and tag  

This captures all changes made inside the container as a new image layer.

### Step 5: Verify New Image  

```bash
docker images
```
#### Explanation:  
This command lists all images again.  

We run this to confirm:
- New image `ecommerce:nautilus` is created  
- It has a new IMAGE ID  

### Step 6: (Optional) Test New Image  

```bash
docker run -it ecommerce:nautilus /bin/bash
```
#### Explanation:  
The `docker run` command creates and starts a container from the image.  
- `-it` flag provides interactive terminal  

We run this to verify that the new image contains expected changes.

---

## Key Learnings  
- `docker commit` creates image from container state  
- Captures installed packages, files, and configurations  
- Does not affect the running container  
- Useful for backup and quick prototyping  
- Prefer Dockerfile for production-level builds  
