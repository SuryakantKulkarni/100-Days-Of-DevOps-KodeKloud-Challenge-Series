# Day 80 – Jenkins Chained Builds

---

## Task Overview  
The DevOps team was looking for a solution where they want to restart Apache service on all app servers if the deployment goes fine on these servers in Stratos Datacenter. After having a discussion, they came up with a solution to use Jenkins chained builds so that they can use a downstream job for services which should only be triggered by the deployment job. So as per the requirements mentioned below configure the required Jenkins jobs.

Click on the `Jenkins` button on the top bar to access the Jenkins UI. Login using username `admin` and `Adm!n321` password.

Similarly, you can access the `Gitea UI` using `Gitea` button and Username and password for Git are `sarah` and `Sarah_pass123` respectively. Under user `sarah` you will find a repository named `web.

Apache is already installed and configured on the app server. The doc root `/var/www/html` on **App Server 1** is a local git repository tracking the origin `web` repository.

1. Create a Jenkins job named `xfusion-app-deployment` and configure it to pull changes from the `master` branch of the `web` repository on **App Server 1** under `/var/www/html` directory.

2. Create another Jenkins job named `manage-services` and make it a `downstream job` for `xfusion-app-deployment`. Things to take care about this job are:

a. This job should restart `httpd` service on the app server (App Server 1).

b. Trigger this job only if the `upstream job` i.e `xfusion-app-deployment` is stable.

The LB server is already configured. Click on the `App` button on the top bar to access the app. Please make sure the required content is loading on the main URL (e.g. http://stlb01:8091) i.e there should not be a sub-directory like http://stlb01:8091/web etc.

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
ssh tony@stapp01

cd /var/www/html
git status
git remote -v

sudo chown -R sarah:sarah /var/www/html
sudo chmod -R 755 /var/www/html

echo "sarah ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/sarah
sudo chmod 440 /etc/sudoers.d/sarah

sudo yum install -y java-17-openjdk

sudo systemctl start httpd
sudo systemctl enable httpd

sudo mkdir -p /home/sarah/jenkins_agent
sudo chown -R sarah:sarah /home/sarah/jenkins_agent
```

#### Explanation:  
This step ensures the repo exists, permissions are correct, sudo is enabled, Java is installed, and Apache is running.

### Step 2: Install Required Plugins  

| Plugin |
|-------|
| SSH Build Agents |
| Git |
| Pipeline |
| Gitea |

#### Explanation:  
These plugins enable Jenkins to connect, pull code, and trigger builds.

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
Credentials allow Jenkins to access the server and repository.

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
This connects Jenkins to App Server 1 for job execution.

### Step 5: Create Upstream Job  

| Field | Value |
|------|------|
| Job Name | xfusion-app-deployment |
| Type | Freestyle Project |

#### Explanation:  
This job pulls latest code and deploys it.

### Step 6: Configure SCM  

| Field | Value |
|------|------|
| SCM | Git |
| Repository URL | <GITEA-URL>/sarah/web.git |
| Credentials | gitea-sarah-creds |
| Branch | */master |

#### Explanation:  
This ensures Jenkins pulls code from master branch.

### Step 7: Configure Build Trigger  

| Option | Value |
|-------|------|
| Poll SCM | * * * * * |

#### Explanation:  
This checks for changes every minute.

### Step 8: Configure Build Step  

```bash
#!/bin/bash
set -e

cd /var/www/html

sudo git config --global --add safe.directory /var/www/html
sudo git fetch origin
sudo git reset --hard origin/master
sudo git pull origin master

sudo chown -R sarah:sarah /var/www/html
sudo chmod -R 755 /var/www/html
```

#### Explanation:  
This pulls latest code safely and ensures clean deployment.

### Step 9: Add Post-Build Action  

| Field | Value |
|------|------|
| Projects to build | manage-services |
| Trigger | Only if build is stable |

#### Explanation:  
This triggers downstream job only when deployment succeeds.

### Step 10: Create Downstream Job  

| Field | Value |
|------|------|
| Job Name | manage-services |
| Type | Freestyle Project |

#### Explanation:  
This job handles service restart.

### Step 11: Configure Downstream Trigger  

| Field | Value |
|------|------|
| Trigger Type | Build after other projects |
| Upstream Project | xfusion-app-deployment |
| Condition | Only if build is stable |

#### Explanation:  
This ensures job runs only after successful deployment.

### Step 12: Configure Build Step (Restart Service)  

```bash
#!/bin/bash
set -e

sudo systemctl restart httpd
sudo systemctl status httpd
```

#### Explanation:  
This restarts Apache service and verifies it is running.

### Step 13: Test Build  

```
Build Now → xfusion-app-deployment
```

#### Explanation:  
This triggers deployment and automatically runs downstream job.

### Step 14: Verify Deployment  

```bash
ssh sarah@stapp01

ls -la /var/www/html/
cat /var/www/html/index.html

sudo systemctl status httpd
```

#### Explanation:  
This confirms deployment and service restart.

---

## Key Learnings  
- Chained builds automate multi-step workflows  
- Downstream jobs depend on upstream success  
- git reset ensures clean repeated deployments  
- Service restart should be separated into another job  
