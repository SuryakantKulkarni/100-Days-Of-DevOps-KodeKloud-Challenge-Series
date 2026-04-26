# Day 79 – Jenkins Deployment Job (Auto Trigger)

---

## Task Overview  
The Nautilus development team had a meeting with the DevOps team where they discussed automating the deployment of one of their apps using Jenkins (the one in `Stratos Datacenter`). They want to auto deploy the new changes in case any developer pushes to the repository. As per the requirements mentioned below configure the required Jenkins job.

Click on the `Jenkins` button on the top bar to access the Jenkins UI. Login using username `admin` and `Adm!n321` password.

Similarly, you can access the `Gitea UI` using `Gitea` button. Username and password for Git are `sarah` and `Sarah_pass123`. Under user `sarah` you will find a repository named `web` that is already cloned on App Server 1 under sarah's home (`/home/sarah/web`). `sarah` is a developer who is working on this repository.

- `httpd` is already installed and configured on the app server (listening on port `8080`). Ensure the `httpd` service is running on App Server 1 (e.g. start it manually if needed). You can make starting/restarting httpd part of your Jenkins job if you prefer.

- Create a Jenkins job named `xfusion-app-deployment` and configure it so that if anyone pushes any new change to the origin repository in `master` branch, the job should auto build and deploy the latest code on **App Server 1** under `/var/www/html` directory. Before deployment, ensure that the ownership of the `/var/www/html` directory is set to user `sarah`, so that Jenkins can successfully deploy files to that directory.

- SSH into **App Server 1** using `sarah` user credentials mentioned above. Under sarah user's home (`/home/sarah/web`) you will find a cloned Git repository named `web`. Under this repository there is an `index.html` file, update its content to `Welcome to the xFusionCorp Industries`, then push the changes to the `origin` into `master` branch. This push must trigger your Jenkins job and the latest changes must be deployed on the server, also make sure it deploys the entire repository content not only `index.html` file.

Click on the `App` button on the top bar to access the app. Please make sure the required content is loading on the main URL (e.g. http://stlb01:8091) i.e there should not be any sub-directory like http://stlb01:8091/web etc.

`Note:`

- You might need to install some plugins and restart Jenkins service. So, we recommend clicking on `Restart Jenkins when installation is complete and no jobs are running` on plugin installation/update page i.e update centre. Also some times Jenkins UI gets stuck when Jenkins service restarts in the back end so in such case please make sure to refresh the UI page.

- Make sure Jenkins job passes even on repetitive runs as validation may try to build the job multiple times.

- Deployment related tasks should be done by `sudo` user on the destination server to avoid any permission issues so make sure to configure your Jenkins job accordingly.

- For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.

---

#### 🔐 Credentials  

| Component | User | Password |
|----------|------|----------|
| Jenkins | admin | Adm!n321 |
| Gitea | sarah | Sarah_pass123 |
| App Server 1 | sarah | Sarah_pass123 |

---

## Step-by-Step Implementation  

### Step 1: Prepare App Server  

```bash
ssh sarah@stapp01

sudo systemctl start httpd
sudo systemctl enable httpd

sudo chown -R sarah:sarah /var/www/html
sudo chmod -R 755 /var/www/html

echo "sarah ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/sarah
sudo chmod 440 /etc/sudoers.d/sarah

sudo yum install -y java-17-openjdk

mkdir -p /home/sarah/jenkins_agent
```

#### Explanation:  
This step ensures Apache is running, permissions are correct, sudo access is enabled, and Java is installed for Jenkins agent.

### Step 2: Install Required Plugins  

| Plugin |
|-------|
| SSH Build Agents |
| Git |
| Pipeline |
| Gitea |

#### Explanation:  
These plugins enable Jenkins to connect to servers, fetch code, and trigger builds from Git events.


### Step 3: Add Credentials  

#### SSH Credential  

| Field | Value |
|------|------|
| Kind | Username with password |
| Username | sarah |
| Password | Sarah_pass123 |
| ID | sarah-creds |

#### Gitea Credential  

| Field | Value |
|------|------|
| Kind | Username with password |
| Username | sarah |
| Password | Sarah_pass123 |
| ID | gitea-sarah-creds |

#### Explanation:  
These credentials allow Jenkins to connect to the server and access the repository.

### Step 4: Add Jenkins Agent Node  

| Field | Value |
|------|------|
| Node Name | App Server 1 |
| Type | Permanent Agent |
| Remote Directory | /home/sarah/jenkins_agent |
| Labels | stapp01 |
| Launch Method | SSH |
| Host | stapp01 |
| Credentials | sarah-creds |
| Java Path | /usr/bin/java |

#### Explanation:  
This connects Jenkins to App Server 1 so jobs can run directly on it.

### Step 5: Create Jenkins Job  

| Field | Value |
|------|------|
| Job Name | xfusion-app-deployment |
| Type | Freestyle Project |

#### Explanation:  
Freestyle job is used here for simple deployment automation.

### Step 6: Restrict Job to Node  

```
Restrict where this project can be run → stapp01
```

#### Explanation:  
This ensures deployment runs only on App Server 1.

### Step 7: Configure Source Code Management  

| Field | Value |
|------|------|
| SCM | Git |
| Repository URL | <GITEA-URL>/sarah/web.git |
| Credentials | gitea-sarah-creds |
| Branch | */master |

#### Explanation:  
This tells Jenkins to pull code from the master branch.

### Step 8: Configure Build Trigger  

| Option | Value |
|-------|------|
| Poll SCM | * * * * * |
| Webhook | Gitea Trigger |

#### Explanation:  
Webhook triggers build on push, while Poll SCM acts as backup.

### Step 9: Configure Build Step  

```bash
#!/bin/bash
set -e

sudo chown -R sarah:sarah /var/www/html
sudo chmod -R 755 /var/www/html

sudo rm -rf /var/www/html/*
sudo rm -rf /var/www/html/.[^.]*

sudo cp -rf $WORKSPACE/. /var/www/html/
sudo rm -rf /var/www/html/.git

sudo chown -R sarah:sarah /var/www/html/
sudo chmod -R 755 /var/www/html/

sudo systemctl start httpd || true
```

#### Explanation:  
This script cleans old files, copies the entire repo, sets permissions, and ensures Apache is running.

### Step 10: Configure Gitea Webhook  

| Field | Value |
|------|------|
| URL | http://jenkins:8080/gitea-webhook/post |
| Method | POST |
| Trigger | Push Events |

#### Explanation:  
This sends a trigger to Jenkins whenever code is pushed.

### Step 11: Test Manual Build  

```
Build Now
```

#### Explanation:  
This verifies that deployment works before automation.

### Step 12: Update Code and Push  

```bash
ssh sarah@stapp01
cd /home/sarah/web

echo "Welcome to the xFusionCorp Industries" > index.html

git add .
git commit -m "update index"
git push origin master
```

#### Explanation:  
This updates the repository and triggers Jenkins automatically.

### Step 13: Verify Deployment  

```bash
ssh sarah@stapp01

ls -la /var/www/html/
cat /var/www/html/index.html

curl http://localhost:8080/
```

#### Explanation:  
This confirms that files are deployed and the application is accessible.

---

## Key Learnings  
- Webhooks enable real-time CI/CD  
- Poll SCM acts as fallback trigger  
- Clean deployment avoids conflicts  
- Jenkins workspace is used for fresh code  
- Proper permissions prevent deployment failures  
