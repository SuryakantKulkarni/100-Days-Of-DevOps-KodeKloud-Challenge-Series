# Day 43 – Docker Port Mapping

---

## Task Overview  
The Nautilus DevOps team is planning to host an application on a nginx-based container. There are number of tickets already been created for similar tasks. One of the tickets has been assigned to set up a nginx container on `Application Server 1` in `Stratos Datacenter`. Please perform the task as per details mentioned below:

- Pull `nginx:stable` docker image on `Application Server 1`.

- Create a container named `official` using the image you pulled.

- Map host port `8089` to container port `80`. Please keep the container in running state.

---

## Step-by-Step Implementation  

### Step 1: Connect to App Server  

```bash
ssh tony@stapp01
```
#### Explanation:  
The `ssh` command connects securely to App Server 1. We run this to access the Docker host where the container will be created.

### Step 2: Pull Docker Image  

```bash
docker pull nginx:stable
```
#### Explanation:  
The `docker pull` command downloads the image from Docker Hub.  
- `nginx` is the image name  
- `stable` is a lightweight version  

We run this to get the required web server image locally.

### Step 3: Run Container with Port Mapping  

```bash
docker run -d --name official -p 8089:80 nginx:stable
```
#### Explanation:  
- `docker run` creates and starts container  
- `-d` runs container in background  
- `--name official` assigns container name  
- `-p 8089:80` maps host port → container port  

This means:
- Host port `8089` → Container port `80`  

We run this to expose the Nginx service outside the container.

### Step 4: Verify Container Running  

```bash
docker ps
```
#### Explanation:  
The `docker ps` command lists running containers.  

We run this to confirm:
- Container `official` is running  
- Port mapping is correctly applied  

### Step 5: Test Application  

```bash
curl http://localhost:8089
```
#### Explanation:  
The `curl` command sends an HTTP request. We run this to verify that Nginx is accessible via mapped port.

### Step 6: Check Port Mapping (Optional)  

```bash
docker port official
```
#### Explanation:  
Displays port mappings for the container. We run this to confirm correct host-to-container port binding.

---

## Key Learnings  
- Port mapping exposes container services to host  
- `-p host:container` defines traffic routing  
- Containers remain isolated but accessible  
- Multiple ports can be mapped if required  
- Always verify service using curl or browser  
