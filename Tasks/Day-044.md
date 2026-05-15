# Day 44 – Write a Docker Compose File

---

## Task Overview  
The Nautilus application development team shared static website content that needs to be hosted on the `httpd` web server using a containerised platform. The team has shared details with the DevOps team, and we need to set up an environment according to those guidelines. Below are the details:

- On `App Server 1` in `Stratos DC` create a container named `httpd` using a docker compose file `/opt/docker/docker-compose.yml` (please use the exact name for file).

- Use `httpd` (preferably `latest` tag) image for container and make sure container is named as `httpd`; you can use any name for service.

- Map `80` number port of container with port `3003` of docker host.

- Map container's `/usr/local/apache2/htdocs` volume with `/opt/data` volume of docker host which is already there. (please do not modify any data within these locations).

---

## Step-by-Step Implementation

### Step 1: Connect to App Server  

```bash
ssh tony@stapp01
```
#### Explanation:  
The `ssh` command connects securely to App Server 1. We run this to access the system where the compose file will be created.

### Step 2: Create Directory (if not exists)  

```bash
sudo mkdir -p /opt/docker
```
#### Explanation:  
The `mkdir -p` command creates directory and avoids error if it already exists. We run this to store the Docker Compose file in correct location.

### Step 3: Create Docker Compose File  

```bash
sudo vi /opt/docker/docker-compose.yml
```
#### Explanation:  
The `vi` editor is used to create and edit the compose file. The file name must be exactly **docker-compose.yml**.

### Step 4: Add Configuration  

```yaml
version: '3.8'

services:
  web:
    image: httpd:latest
    container_name: httpd
    ports:
      - "3003:80"
    volumes:
      - /opt/data:/usr/local/apache2/htdocs
```
#### Explanation:  
- `version` defines compose format  
- `services` defines container services  
- `image` specifies Apache image  
- `container_name` sets container name  
- `ports` maps host → container port  
- `volumes` binds host directory to container  

We define this to run Apache and serve static files from host.

### Step 5: Verify File  

```bash
cat /opt/docker/docker-compose.yml
```
#### Explanation:  
Displays file content. We run this to ensure configuration is correct before deployment.

### Step 6: Start Container  

```bash
docker compose -f /opt/docker/docker-compose.yml up -d
```
#### Explanation:  
- `docker compose up` creates and starts services  
- `-f` flag specifies file path  
- `-d` flag runs container in background  

We run this to deploy the httpd container.

### Step 7: Verify Running Container  

```bash
docker ps
```
#### Explanation:  
Lists running containers.  

We run this to confirm:
- Container name is `httpd`  
- Port mapping is active  

### Step 8: Test Application  

```bash
curl http://localhost:3003
```
#### Explanation:  
The `curl` command sends HTTP request. We run this to verify Apache is serving content from mapped volume.

---

## Key Learnings  
- `Docker Compose` manages containers using YAML  
- Services define container configurations  
- Port mapping exposes container services  
- Volumes allow sharing data between host and container  
- Compose simplifies multi-container deployments  
