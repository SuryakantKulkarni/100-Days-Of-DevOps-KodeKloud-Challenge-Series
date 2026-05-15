# Day 36 – Deploy Nginx Container on Application Server

---

## Task Overview  
The Nautilus DevOps team is conducting application deployment tests on selected application servers. They require a nginx container deployment on Application Server 2. Complete the task with the following instructions:

On Application Server 2 create a container named `nginx_2` using the `nginx` image with the `alpine` tag. Ensure container is in a `running` state. 

---

## Step-by-Step Implementation  

### Step 1: Connect to Application Server  
```bash
ssh steve@app-server-2
```
#### Explanation:  
The `ssh` command is used to connect to a remote server securely.

We run this command to access Application Server 2 where the container will be deployed.

### Step 2: Run Nginx Container  
```bash
sudo docker run -d --name nginx_2 nginx:alpine
```
#### Explanation:  
The `docker run` command is used to create and start a new container.
- `-d` flag runs the container in detached mode, meaning it runs in the background.
- `--name nginx_2` assigns a custom name to the container for easy identification.
- `nginx:alpine` specifies the Docker image, where:
  - `nginx` is the web server  
  - `alpine` is a lightweight Linux distribution  

If the image is not present locally, Docker automatically pulls it from Docker Hub. We run this command to deploy the Nginx container.

### Step 3: Verify Container Status  
```bash
sudo docker ps
```
#### Explanation:  
The `docker ps` command lists all running containers. It shows details like container ID, image, status, ports, and name.

We run this command to confirm that the `nginx_2` container is in running state.

### Step 4: (Optional) Check All Containers  
```bash
sudo docker ps -a
```
#### Explanation:  
The `docker ps -a` command shows all containers including stopped ones.

We run this command to debug if the container is not running.

### Step 5: (Optional) Test Container  

```bash
curl http://localhost
```
#### Explanation:  
The `curl` command sends an HTTP request to the container.

We run this command to verify that Nginx is serving the default web page.

---

## Best Practices  
- Use lightweight images like alpine  
- Always name containers clearly  
- Verify container after deployment  
- Use logs for debugging  

## Key Learnings  

- Docker simplifies application deployment  
- Containers are lightweight and fast  
- `docker run` is the core command  
- Verification is critical after deployment  
