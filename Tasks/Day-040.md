# Day 40 – Docker EXEC Operations

---

## Task Overview  
One of the Nautilus DevOps team members was working to configure services on a `kkloud` container that is running on `App Server 1` in `Stratos Datacenter`. Due to some personal work he is on PTO for the rest of the week, but we need to finish his pending work ASAP. Please complete the remaining work as per details given below:

- Install `apache2` in `kkloud` container using `apt` that is running on `App Server 1` in `Stratos Datacenter`.
  
- Configure Apache to listen on port `5000` instead of default `http` port. Do not bind it to listen on specific IP or hostname only, i.e it should listen on localhost, 127.0.0.1, container ip, etc.

- Make sure Apache service is up and running inside the container. Keep the container in running state at the end.

---

## Step-by-Step Implementation  

---

### Step 1: Connect to App Server  

```bash
ssh tony@stapp01
```
#### Explanation:  
The `ssh` command connects securely to App Server 1. We run this to access the Docker host where the container is running.

### Step 2: Verify Running Container  

```bash
docker ps
```
#### Explanation:  
The `docker ps` command lists all running containers. We run this to confirm that the `kkloud` container is active.

### Step 3: Access Container Shell  

```bash
docker exec -it kkloud /bin/bash
```
#### Explanation:  
The `docker exec` command runs a command inside a running container.  
- `-i` flag keeps input stream open  
- `-t` flag provides terminal access  
- `/bin/bash` opens shell  

We run this to enter the container and perform configuration tasks.

### Step 4: Install Apache  

```bash
apt update && apt install apache2 -y
```
#### Explanation:  
- `apt update` refreshes package list  
- `apt install apache2` installs web server  
- `-y` flag auto-confirms installation  

We run this to install Apache inside the container.

### Step 5: Install Editor (Optional)  

```bash
apt install vim -y
```
#### Explanation:  
Installs a text editor for modifying configuration files. We run this to easily edit Apache config files.

### Step 6: Change Apache Port  

```bash
vim /etc/apache2/ports.conf
```
#### Update:
```
Listen 5000
```
#### Explanation:  
The `ports.conf` file defines Apache listening ports. We change port `80` → `5000` so Apache listens on the required port.

### Step 7: Restart Apache Service  

```bash
service apache2 restart
```
#### Explanation:  
The `service` command manages services inside container. We run this to apply configuration changes and restart Apache.

### Step 8: Verify Apache Status  

```bash
service apache2 status
```
#### Explanation:  
This command checks if Apache is running. We run this to ensure service is active after configuration.

### Step 9: Exit Container  

```bash
exit
```
#### Explanation:  
The `exit` command closes container shell session. Container continues running in background.

---

## Key Learnings  
- `docker exec` allows running commands inside containers  
- Containers can be modified without rebuilding images  
- Apache config files control service behavior  
- Services must be restarted after config changes  
- Container keeps running even after exiting shell  
