# Day 46 – Deploy an App on Docker Containers

---

## Task Overview  
The Nautilus Application development team recently finished development of one of the apps that they want to deploy on a containerized platform. The Nautilus Application development and DevOps teams met to discuss some of the basic pre-requisites and requirements to complete the deployment. The team wants to test the deployment on one of the app servers before going live and set up a complete containerized stack using a docker compose fie. Below are the details of the task:

- On `App Server 2` in `Stratos Datacenter` create a docker compose file `/opt/security/docker-compose.yml` (should be named exactly).

- The compose should deploy two services (web and DB), and each service should deploy a container as per details below:

`For web service:`

  - Container name must be `php_blog`.
  
  - Use image `php` with any `apache` tag. Check [DockerHub](https://hub.docker.com/_/php?tab=tags/) for more details.

  - Map `php_blog` container's port `80` with host port `6300`

  - Map `php_blog` container's `/var/www/html` volume with host volume `/var/www/html`.

`For DB service:`

  - Container name must be `mysql_blog`.

  - Use image `mariadb` with any tag (preferably `latest`). Check [mariadb](https://hub.docker.com/_/mariadb?tab=tags/) for more details.

  - Map `mysql_blog` container's port `3306` with host port `3306`

  - Map `mysql_blog` container's `/var/lib/mysql` volume with host volume `/var/lib/mysql`.

  - Set MYSQL_DATABASE=`database_blog` and use any custom user ( except root ) with some complex password for DB connections.

- After running docker-compose up you can access the app with curl command curl <server-ip or hostname>:6400/

`For more details check [mariadb](https://hub.docker.com/_/mariadb?tab=description/).

> Note: Once you click on FINISH button, all currently running/stopped containers will be destroyed and stack will be deployed again using your compose file.

---

## Step-by-Step Implementation  

### Step 1: Connect to Server  
```bash
ssh steve@stapp02.stratos.xfusioncorp.com
```
#### Explanation:
Connect to App Server 2 using SSH. We run this to access deployment environment.

### Step 2: Create Directory
```bash
sudo mkdir -p /opt/security
```
#### Explanation:
mkdir creates directory for compose file.
- `-p` ensures directory is created if not exists.

### Step 3: Create Docker Compose File
```bash
sudo tee /opt/security/docker-compose.yml > /dev/null << 'EOF'
# docker-compose content
EOF
```
#### Explanation:
Creates compose file using tee. We define services, ports, volumes, and environment variables.

Copy-Paste content from YAML File: [Day-46 Docker Compose File →](Configs/Day-46-docker-Deploy-App-on-Docker.yml)

### Step 4: Deploy Application
```bash
cd /opt/security
sudo docker compose up -d
```
#### Explanation:
- `docker compose` up → starts services
- `-d` → runs in background
We run this to deploy application stack.

### Step 5: Verify Containers
```bash
sudo docker ps
```
#### Explanation:
docker ps lists running containers. We run this to confirm both services are running.

### Step 6: Test Application
```bash
curl http://localhost:6300/
```
#### Explanation:
Sends HTTP request to web service. We run this to verify application is accessible.

---

## Config / docker-compose.yml
```bash
version: '3.8'
services:
  web:
    image: php:8.2-apache
    container_name: php_blog
    ports:
      - "6300:80"
    volumes:
      - /var/www/html:/var/www/html
    depends_on:
      - db

  db:
    image: mariadb:latest
    container_name: mysql_blog
    ports:
      - "3306:3306"
    volumes:
      - /var/lib/mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: R00t@Secure#2024
      MYSQL_DATABASE: database_blog
      MYSQL_USER: blog_admin
      MYSQL_PASSWORD: Bl0g@Secure#2024
```

---

## Key Learnings
- Docker Compose simplifies multi-container setup
- Services can be managed as a single unit
- Volumes ensure data persistence
- Port mapping enables external access
- Essential for real-world DevOps deployments

---

**Next Challenge:** [Day 47 →](Tasks/Day-47.md)
