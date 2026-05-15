# Day 35 – Install Docker & Start Docker Service

---

## Task Overview  
The Nautilus DevOps team aims to containerize various applications following a recent meeting with the application development team. They intend to conduct testing with the following steps:

- Install `docker-ce` and `docker compose` packages on `App Server 1`.
- Initiate the `docker` service.  

---

## Step-by-Step Implementation  

### Step 1: Connect to Application Server  
```bash
ssh tony@app-server-1
```
#### Explanation:  
The `ssh` command is used to securely connect to a remote server.

We run this command to access Application Server 1.

### Step 2: Check Operating System  
```bash
cat /etc/os-release
```
#### Explanation:  
The `cat` command displays the content of a file.

The `/etc/os-release` file contains OS details like name and version.

We run this command to determine the package manager (yum for CentOS).

### Step 3: Install Required Utilities  
```bash
sudo yum install -y yum-utils
```
#### Explanation:  
The `yum install` command installs required packages.
- `yum-utils` package provides utilities for managing repositories.
- `-y` flag automatically confirms installation.

We run this command to enable repository management.

### Step 4: Add Docker Repository  
```bash
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```
#### Explanation:  
The `yum-config-manager` command manages yum repositories.

The `--add-repo` option adds Docker’s official repository.

We run this command to install Docker from the official source.

### Step 5: Install Docker Packages  
```bash
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
#### Explanation:  
This command installs Docker Engine and related components.
- `docker-ce` → Docker Engine  
- `docker-ce-cli` → Command-line interface  
- `containerd.io` → Container runtime  
- `docker-buildx-plugin` → Advanced build tool  
- `docker-compose-plugin` → Multi-container support  

We run this command to install complete Docker environment.

### Step 6: Start Docker Service  
```bash
sudo systemctl start docker
```
#### Explanation:  
The `systemctl start` command starts a service immediately.

We run this command to start the Docker daemon.

### Step 7: Enable Docker Service  
```bash
sudo systemctl enable docker
```
#### Explanation:  
The `systemctl enable` command ensures the service starts automatically at boot.

We run this command so Docker runs after system restart.

### Step 8: Verify Docker Service  
```bash
sudo systemctl status docker
```
#### Explanation:  
The `systemctl status` command shows service status.

We run this command to confirm Docker is running.

### Step 9: Verify Docker Installation  
```bash
docker --version
```
#### Explanation:  
The `docker --version` command displays installed Docker version.

We run this command to confirm successful installation.

### Step 10: Verify Docker Compose  
```bash
docker compose version
```
#### Explanation:  
The `docker compose version` command checks Docker Compose plugin.

We run this command to confirm Compose is installed.

### Step 11: Test Docker (Optional)  
```bash
sudo docker run hello-world
```

#### Explanation:  
The `docker run` command creates and runs a container.

We run this command to verify Docker is working correctly.

---

## Best Practices  
- Always install from official repository  
- Enable Docker service for production  
- Verify installation after setup  
- Use lightweight images when possible  

## Key Learnings  
- Docker installation requires repository setup  
- Services must be started and enabled  
- Verification is critical after installation  
- Docker Compose is essential for multi-container apps  
