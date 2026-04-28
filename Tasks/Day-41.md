# Day 41 – Write a Dockerfile

---

## Task Overview  
As per recent requirements shared by the Nautilus application development team, they need custom images created for one of their projects. Several of the initial testing requirements are already been shared with DevOps team. Therefore, create a docker file `/opt/docker/Dockerfile` (please keep `D` capital of Dockerfile) on `App server 1` in `Stratos DC` and configure to build an image with the following requirements:

- Use `ubuntu:24.04` as the base image.

- Install `apache2` and configure it to work on `3004` port. (do not update any other Apache configuration settings like document root etc).

---

## Step-by-Step Implementation  

### Step 1: Connect to App Server  

```bash
ssh tony@stapp01
```
#### Explanation:  
The `ssh` command connects securely to App Server 1. We run this to access the system where Dockerfile will be created.

### Step 2: Create Directory  

```bash
sudo mkdir -p /opt/docker
cd /opt/docker
```
#### Explanation:  
- `mkdir -p` creates directory and avoids error if exists  
- `cd` changes working directory  

We run this to organize Docker files in a proper location.

### Step 3: Create Dockerfile  

```bash
sudo vi Dockerfile
```
#### Explanation:  
The `vi` editor is used to create and edit the Dockerfile. File name must be exactly **Dockerfile (capital D)**.

### Step 4: Add Dockerfile Content  

```dockerfile
# Base image
FROM ubuntu:24.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install Apache
RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Change Apache port to 3004
RUN sed -i 's/Listen 80/Listen 3004/' /etc/apache2/ports.conf && \
    sed -i 's/<VirtualHost \*:80>/<VirtualHost *:3004>/' /etc/apache2/sites-available/000-default.conf

# Expose port
EXPOSE 3004

# Run Apache in foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```

#### Explanation:  
- `FROM` sets base image  
- `ENV` disables interactive prompts  
- `RUN` installs Apache and cleans cache  
- `sed` modifies Apache port configuration  
- `EXPOSE` documents port  
- `CMD` runs Apache in foreground  

We define all steps to build a reusable custom image.

### Step 5: Verify Dockerfile  

```bash
cat Dockerfile
```
#### Explanation:  
Displays file content. We run this to confirm Dockerfile is written correctly.

### Step 6: Build Docker Image  

```bash
docker build -t custom-apache:latest .
```
#### Explanation:  
- `docker build` creates image  
- `-t` flag assigns name and tag  
- `.` defines current directory as build context  

We run this to generate the Docker image from Dockerfile.

### Step 7: Verify Image  

```bash
docker images
```
#### Explanation:  
Lists all images. We run this to confirm the image was created successfully.

### Step 8: Test Container (Optional)  

```bash
docker run -d --name test-apache -p 3004:3004 custom-apache:latest
```
#### Explanation:  
- `-d` runs container in background  
- `-p` maps host port to container port  

We run this to test if Apache is working on port 3004.

### Step 9: Verify Application  

```bash
curl http://localhost:3004
```
#### Explanation:  
The `curl` command sends HTTP request. We run this to confirm Apache is serving content.

---

## Key Learnings  
- `Dockerfile` automates image creation  
- Each instruction creates a new image layer  
- `RUN` installs software and modifies system  
- `CMD` keeps container running  
- Port changes require config update + expose  
