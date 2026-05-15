# Day 42 – Create Docker Network

---

## Task Overview  
The Nautilus DevOps team needs to set up several docker environments for different applications. One of the team members has been assigned a ticket where he has been asked to create some docker networks to be used later. Complete the task based on the following ticket description:

- Create a docker network named as `beta` on `App Server 3` in `Stratos DC`.

- Configure it to use `bridge` drivers.

- Set it to use subnet `172.28.0.0/24` and iprange `172.28.0.0/24`.

---

## Step-by-Step Implementation  

### Step 1: Connect to App Server  

```bash
ssh banner@stapp03
```
#### Explanation:  
The `ssh` command connects securely to App Server 3. We run this to access the system where the Docker network will be created.

### Step 2: Verify Existing Networks  

```bash
docker network ls
```
#### Explanation:  
The `docker network ls` command lists all available Docker networks. We run this to check existing networks and avoid naming conflicts.

### Step 3: Create Docker Network  

```bash
docker network create -d bridge \
  --subnet=172.28.0.0/24 \
  --ip-range=172.28.0.0/24 \
  beta
```
#### Explanation:  
- `docker network create` creates a new network  
- `-d bridge` specifies macvlan driver  
- `--subnet` defines network range  
- `--ip-range` defines IP allocation range  
- `beta` is the network name  

We run this to create a custom network where containers can get IPs from defined range.

### Step 4: Verify Network Creation  

```bash
docker network ls
```
#### Explanation:  
Lists networks again. We run this to confirm that the `beta` network is successfully created.

### Step 5: Inspect Network Details  

```bash
docker network inspect beta
```
#### Explanation:  
The `docker network inspect` command shows detailed configuration. We run this to verify subnet, IP range, and driver settings.

---

## Key Learnings  
- Docker networks isolate container communication  
- bridge assigns containers real network identities  
- Subnet defines total network range  
- IP-range controls assignable container IPs  
- Always verify network after creation  
