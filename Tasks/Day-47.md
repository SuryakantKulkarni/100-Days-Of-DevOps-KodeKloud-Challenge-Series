# Day 47 – Docker Python App

---

## Task Overview  
A python app needs to be Dockerized, and then it needs to be deployed on `App Server 1`. We have already copied a `requirements.txt` file (having the app dependencies) under `/python_app/src/` directory on `App Server 1`. Further complete this task as per details mentioned below:

- Create a `Dockerfile` under `/python_app` directory:

  - Use any `python` image as the base image.
  - Install the dependencies using `requirements.txt` file.
  - Expose the port `6100`.
  - Run the `server.py` script using `CMD`.

- Build an image named `nautilus/python-app` using this Dockerfile.

- Once image is built, create a container named `pythonapp_nautilus`:

  - Map port `6100` of the container to the host port `8098`.

- Once deployed, you can test the app using `curl` command on `App Server 1`.  

---

## Step-by-Step Implementation  

### Step 1: Connect to Server  
```bash
ssh tony@stapp01.stratos.xfusioncorp.com
```
#### Explanation:
Establish an SSH connection to Application Server 1 in the Stratos Datacenter. This server contains the Python application source code that needs to be containerized.

We run this to access the environment where the app is deployed.

### Step 2: Verify Application Files
```bash
cat /python_app/src/requirements.txt
ls /python_app/src/
```
#### Explanation:
These commands checks dependencies and source files. We run this to confirm required files exist.

### Step 3: Create Dockerfile
```bash 
cat > /python_app/Dockerfile << 'EOF'
# Dockerfile content
EOF
```
#### Explanation:
Creates Dockerfile using `cat`. We define how container image will be built.

### Step 4: Build Docker Image
```bash
cd /python_app
docker build -t nautilus/python-app .
```
#### Explanation:
The `docker build` command builds Docker image from Dockerfile.
- `-t` flag tags the image with the specified name, making it easy to reference later.
- `.` argument specifies the build context as the current directory.

### Step 5: Verify Image
```bash
docker images | grep nautilus/python-app
```
#### Explanation:
The `docker images` command lists all images, and `grep` filters the output.

### Step 6: Run Container
```bash
docker run -d \
--name pythonapp_nautilus \
-p 8098:6100 \
nautilus/python-app
```
#### Explanation:
`docker run` command runs a container from the docker image with specific configuration.
- `-d` flag runs the container in detached mode (background)
- `--name` assigns the exact container name as required
- `-p` maps host port to container port, making the application accessible externally

### Step 7: Verify Container
```bash
docker ps | grep pythonapp_nautilus
```
#### Explanation:
`docker ps` command lists running containers. We run this to confirm container is running.

### Step 8: Test Application
```bash
curl http://localhost:8098/
```
#### Explanation:
Sends HTTP request to application. We run this to verify app is working.

---

## Config / Dockerfile
```bash
FROM python:3.9-slim
WORKDIR /app
COPY src/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY src/ .
EXPOSE 6100
CMD ["python", "server.py"]
```

---

## Key Learnings
- Docker simplifies application deployment
- Containers ensure consistency across environments
- Port mapping enables external access
- Dockerfile design impacts performance
- Essential DevOps skill

---

**Previous Challenge** [← Day 46](Tasks/Day-46.md) 

**Next Challenge:** [Day 48 →](Tasks/Day-48.md)
