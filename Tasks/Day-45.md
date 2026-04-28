# Day 45 – Resolve Dockerfile Issues

---

## Task Overview  
The Nautilus DevOps team is working to create new images per requirements shared by the development team. One of the team members is working to create a `Dockerfile` on `App Server 3` in `Stratos DC`. While working on it she ran into issues in which the docker build is failing and displaying errors. Look into the issue and fix it to build an image as per details mentioned below:

- The `Dockerfile` is placed on `App Server 3` under `/opt/docker` directory.

- Fix the issues with this file and make sure it is able to build the image.

- Do not change base image, any other valid configuration within Dockerfile, or any of the data been used — for example, index.html.

> Note: Please note that once you click on `FINISH` button all the existing containers will be destroyed and new image will be built from your `Dockerfile`.
---

## Step-by-Step Implementation 

### Step 1: Connect to App Server  

```bash
ssh banner@stapp03
```
#### Explanation:  
The `ssh` command connects to App Server 3 securely. We run this to access the system where the faulty Dockerfile is present.

### Step 2: Navigate to Docker Directory  

```bash
cd /opt/docker
```
#### Explanation:  
The `cd` command changes directory. We run this to move into the location where Dockerfile exists.

### Step 3: Check Existing Dockerfile  

```bash
cat Dockerfile
```
#### Explanation:  
Displays Dockerfile content. We run this to identify issues such as wrong paths and incorrect COPY usage.

### Step 4: Fix Dockerfile  

```bash
vi Dockerfile
```
#### Updated Dockerfile:

```dockerfile
FROM httpd:2.4.43

RUN sed -i "s/Listen 80/Listen 8080/g" /usr/local/apache2/conf/httpd.conf

RUN sed -i '/LoadModule\ ssl_module modules\/mod_ssl.so/s/^#//g' /usr/local/apache2/conf/httpd.conf

RUN sed -i '/LoadModule\ socache_shmcb_module modules\/mod_socache_shmcb.so/s/^#//g' /usr/local/apache2/conf/httpd.conf

RUN sed -i '/Include\ conf\/extra\/httpd-ssl.conf/s/^#//g' /usr/local/apache2/conf/httpd.conf

COPY certs/server.crt /usr/local/apache2/conf/server.crt

COPY certs/server.key /usr/local/apache2/conf/server.key

COPY html/index.html /usr/local/apache2/htdocs/
```

#### Explanation:  
- Fixed incorrect relative path → used full path `/usr/local/apache2/conf/httpd.conf`  
- Replaced incorrect `RUN cp` with `COPY`  
- Removed leading `/` from source paths (must be inside build context)  

We correct these so Docker can properly access files during build.

### Step 5: Build Docker Image  

```bash
docker build -t custom-httpd:latest .
```
#### Explanation:  
- `docker build` creates image  
- `-t` flag assigns image name  
- `.` defines current directory as build context  

We run this to verify that Dockerfile builds successfully.

### Step 6: Verify Image  

```bash
docker images
```
#### Explanation:  
Lists all images. We run this to confirm the image is successfully created.

### Step 7: (Optional) Test Container  

```bash
docker run -d -p 8080:8080 custom-httpd:latest
```
#### Explanation:  
Runs container using the new image. We run this to verify Apache runs correctly on port 8080.

---

## Key Learnings  
- COPY copies files from build context  
- RUN cp works only inside container filesystem  
- Correct file paths are critical in Docker builds  
- Build context must contain required files  
- Always verify image after fixing Dockerfile  
