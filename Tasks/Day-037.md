# Day 37 – Copy File to Docker Container

---

## Task Overview  
The Nautilus DevOps team possesses confidential data on `App Server 2` in the `Stratos Datacenter`. A container named `ubuntu_latest` is running on the same server.

Copy an encrypted file `/tmp/nautilus.txt.gpg` from the docker host to the `ubuntu_latest` container located at `/home/`. Ensure the file is not modified during this operation.

---

## Step-by-Step Implementation  

### Step 1: Connect to App Server  

```bash
ssh steve@stapp02
```
#### Explanation:  
The `ssh` command establishes a secure connection to App Server 2. We run this to access the Docker host where the container is running.

### Step 2: Verify Running Container  

```bash
docker ps
```
#### Explanation:  
The `docker ps` command lists all running containers. We run this to confirm that the container `ubuntu_latest` is active and ready.

### Step 3: Verify Source File on Host  

```bash
ls -l /tmp/nautilus.txt.gpg
```
#### Explanation:  
The `ls -l` command displays file details such as permissions, size, and ownership. We run this to ensure the file exists before copying.

### Step 4: Copy File to Container  

```bash
docker cp /tmp/nautilus.txt.gpg ubuntu_latest:/home/
```
#### Explanation:  
The `docker cp` command copies files between host and container.  
- `/tmp/nautilus.txt.gpg` → source file on host  
- `ubuntu_latest:/home/` → destination inside container  

We run this to transfer the file without modifying its content.

### Step 5: Verify File Inside Container  

```bash
docker exec -it ubuntu_latest ls -l /home/
```
#### Explanation:  
The `docker exec` command runs a command inside a container.  
- `-it` flag enables interactive terminal  
- `ls -l` command lists files inside container  

We run this to confirm the file exists in `/home/`.

---

## Key Learnings  
- `docker cp` transfers files between host and container  
- Works without needing container restart  
- File permissions are preserved during copy  
- `docker exec` helps verify container content  
- Checksums ensure file integrity after transfer  
