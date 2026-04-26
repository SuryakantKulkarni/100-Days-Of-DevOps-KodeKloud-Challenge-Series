# Day 75 – Jenkins Slave Nodes (SSH Agents)

---

## Task Overview  
The Nautilus DevOps team has installed and configured new Jenkins server in Stratos DC which they will use for CI/CD and for some automation tasks. There is a requirement to add all app servers as slave nodes in Jenkins so that they can perform tasks on these servers using Jenkins. Find below more details and accomplish the task accordingly.

Click on the `Jenkins` button on the top bar to access the Jenkins UI. Login using username `admin` and password `Adm!n321`.

- Add all app servers as SSH build agent/slave nodes in Jenkins. Slave node name for `app server 1`, `app server 2` and `app server 3` must be `App_server_1`, `App_server_2`, `App_server_3` respectively.

- Add labels as below:
  
  - `App_server_1 : stapp01`
  - `App_server_2 : stapp02`
  - `App_server_3 : stapp03`

- Remote root directory for `App_server_1` must be `/home/tony/jenkins`, for `App_server_2` must be `/home/steve/jenkins` and for `App_server_3` must be `/home/banner/jenkins`.

- Make sure slave nodes are online and working properly.

`Note:`

1. You might need to install some plugins and restart Jenkins service. So, we recommend clicking on `Restart Jenkins when installation is complete and no jobs are running` on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case, please make sure to refresh the UI page.

2. For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.

---

## 🔐 Credentials  

| Component | Host | User | Password |
|----------|------|------|----------|
| Jenkins | jenkins | admin | Adm!n321 |
| App Server 1 | stapp01 | tony | Ir0nM@n |
| App Server 2 | stapp02 | steve | Am3ric@ |
| App Server 3 | stapp03 | banner | BigGr33n |

---

## Step-by-Step Implementation  

### Step 1: Create Jenkins Workspace Directory  

```bash
ssh tony@stapp01
mkdir -p /home/tony/jenkins
exit

ssh steve@stapp02
mkdir -p /home/steve/jenkins
exit

ssh banner@stapp03
mkdir -p /home/banner/jenkins
exit
```

#### Explanation:  
This command creates a directory where Jenkins will store workspace files and run builds on each server.

### Step 2: Install Required Plugin  

Go to:

```
Manage Jenkins → Manage Plugins → Available Plugins
```

Install:

```
SSH Build Agents
```

#### Explanation:  
This plugin allows Jenkins to connect to remote machines using SSH and run jobs on them.

### Step 3: Add Credentials  

Go to:

```
Manage Jenkins → Credentials → Global → Add Credentials
```

#### Add App Server 1  

| Field | Value |
|------|------|
| Username | tony |
| Password | Ir0nM@n |
| ID | appserver1-creds |

#### Add App Server 2  

| Field | Value |
|------|------|
| Username | steve |
| Password | Am3ric@ |
| ID | appserver2-creds |

#### Add App Server 3  

| Field | Value |
|------|------|
| Username | banner |
| Password | BigGr33n |
| ID | appserver3-creds |

#### Explanation:  
These credentials allow Jenkins to authenticate and log into each server securely.

### Step 4: Add Node – App Server 1  

Go to:

```
Manage Jenkins → Nodes → New Node
```

| Field | Value |
|------|------|
| Name | App_server_1 |
| Type | Permanent Agent |
| Remote Directory | /home/tony/jenkins |
| Labels | stapp01 |
| Launch Method | Launch via SSH |
| Host | stapp01 |
| Credentials | appserver1-creds |

### Step 5: Add Node – App Server 2  

| Field | Value |
|------|------|
| Name | App_server_2 |
| Remote Directory | /home/steve/jenkins |
| Labels | stapp02 |
| Host | stapp02 |
| Credentials | appserver2-creds |

### Step 6: Add Node – App Server 3  

| Field | Value |
|------|------|
| Name | App_server_3 |
| Remote Directory | /home/banner/jenkins |
| Labels | stapp03 |
| Host | stapp03 |
| Credentials | appserver3-creds |

### Step 7: Install Java 17 on All App Servers  

```bash
ssh tony@stapp01
sudo yum install -y java-17-openjdk
java -version
exit

ssh steve@stapp02
sudo yum install -y java-17-openjdk
java -version
exit

ssh banner@stapp03
sudo yum install -y java-17-openjdk
java -version
exit
```

#### Explanation:  
Jenkins agents require Java 17 to run properly. Installing Java ensures the agent process can start without failure.

### Step 8: Set Java 17 as Default (if needed)  

```bash
sudo alternatives --config java
```

#### Explanation:  
This command sets Java 17 as the default runtime if multiple versions are installed.

### Step 9: Launch Jenkins Agents  

Go to:

```
Manage Jenkins → Nodes
```

Click:

```
App_server_1 → Launch Agent  
App_server_2 → Launch Agent  
App_server_3 → Launch Agent  
```

#### Explanation:  
This step starts the connection between Jenkins and each server so they become active agents.

### Step 10: Verify Nodes Status  

Expected:

```
App_server_1 → Online  
App_server_2 → Online  
App_server_3 → Online  
```

#### Explanation:  
If all nodes show Online, it means Jenkins can successfully run jobs on all servers.

---

## Key Learnings  
- Jenkins agents allow distributed builds  
- SSH is used for secure remote execution  
- Java version compatibility is critical  
- Labels help target specific servers  
