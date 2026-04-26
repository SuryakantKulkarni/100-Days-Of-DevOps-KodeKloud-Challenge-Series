# Day 77 – Jenkins Deploy Pipeline

---

## Task Overview  
The development team of xFusionCorp Industries is working on to develop a new static website and they are planning to deploy the same on Nautilus App Servers using Jenkins pipeline. They have shared their requirements with the DevOps team and accordingly we need to create a Jenkins pipeline job. Please find below more details about the task:

Click on the `Jenkins` button on the top bar to access the Jenkins UI. Login using username `admin` and password `Adm!n321`.

Similarly, click on the `Gitea` button on the top bar to access the Gitea UI. Login using username `sarah` and password `Sarah_pass123`. There under user `sarah` you will find a repository named `web_app` that is already cloned on **App Server 1** under `/var/www/html`. sarah is a developer who is working on this repository.

- Add a slave node named `App Server 1`. It should be labeled as `stapp01` and its remote root directory should be `/home/sarah/jenkins_agent` (the repository is cloned under `/var/www/html`; the agent uses a separate directory so it does not pollute the repo).

- We have already cloned repository on App Server 1 under `/var/www/html`.

- Apache is already installed on the app server and is running on port `8080`.

- Create a Jenkins pipeline job named `nautilus-webapp-job` (it must not be a `Multibranch pipeline`) and configure it to:

  - Deploy the code from `web_app` repository under `/var/www/html` on App Server 1, as this is the document root of the app server. The pipeline should have a single stage named `Deploy` ( which is case sensitive ) to accomplish the deployment.

LB server is already configured. You should be able to see the latest changes you made by clicking on the `App` button. Please make sure the required content is loading on the main URL `https://<LBR-URL>` i.e there should not be a sub-directory like `https://<LBR-URL>/web_app` etc.

`Note:`

- You might need to install some plugins and restart Jenkins service. So, we recommend clicking on `Restart Jenkins when installation is complete and no jobs are running on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case, please make sure to refresh the UI page.

- For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.

---

#### 🔐 Credentials  

| Component | User | Password |
|----------|------|----------|
| Jenkins | admin | Adm!n321 |
| Gitea | sarah | Sarah_pass123 |
| App Server 1 | tony | Ir0nM@n |

---

## Step-by-Step Implementation  

### Step 1: Prepare App Server  

```bash
ssh tony@stapp01
mkdir -p /home/sarah/jenkins_agent
sudo chown -R sarah:sarah /home/sarah/jenkins_agent
sudo chown -R sarah:sarah /var/www/html
```

#### Explanation:  
This step creates the Jenkins agent directory and gives proper permissions so Jenkins can deploy files to the web server directory.

### Step 2: Install Required Plugins  

Install from Jenkins UI:

| Plugin |
|-------|
| SSH Build Agents |
| Git |
| Pipeline |

#### Explanation:  
These plugins enable Jenkins to connect to remote servers, fetch code from Git, and execute pipeline jobs.

### Step 3: Add SSH Credentials  

| Field | Value |
|------|------|
| Kind | Username with password |
| Username | sarah |
| Password | Sarah_pass123 |
| ID | sarah-appserver1 |

#### Explanation:  
These credentials allow Jenkins to SSH into App Server 1 securely.

### Step 4: Create Jenkins Agent Node  

| Field | Value |
|------|------|
| Node Name | App Server 1 |
| Type | Permanent Agent |
| Remote Root Directory | /home/sarah/jenkins_agent |
| Labels | stapp01 |
| Usage | Use this node as much as possible |
| Launch Method | Launch agents via SSH |
| Host | stapp01 |
| Credentials | sarah-appserver1 |
| Host Key Verification | Non verifying |

#### Explanation:  
This configuration connects Jenkins to App Server 1 so jobs can run directly on that server.

### Step 5: Ensure Node is Online  

```
Manage Jenkins → Nodes → App Server 1 → Launch agent
```

#### Explanation:  
The node must be online for Jenkins to execute pipeline tasks.

### Step 6: Install Java (Required for Agent)  

```bash
ssh tony@stapp01
java -version
sudo yum install -y java-17-openjdk
```

#### Explanation:  
Jenkins agents require Java runtime, so it must be installed on the remote server.

### Step 7: Add Gitea Credentials  

| Field | Value |
|------|------|
| Kind | Username with password |
| Username | sarah |
| Password | Sarah_pass123 |
| ID | gitea-sarah-creds |

#### Explanation:  
These credentials allow Jenkins to access the Git repository.

### Step 8: Create Pipeline Job  

| Field | Value |
|------|------|
| Name | nautilus-webapp-job |
| Type | Pipeline |

#### Explanation:  
Pipeline jobs automate deployment using code instead of manual steps.

### Step 9: Configure Pipeline Script  

```groovy
pipeline {
    agent {
        label 'stapp01'
    }
    stages {
        stage('Deploy') {
            steps {
                git credentialsId: 'gitea-sarah-creds',
                    url: 'http://gitea.stratos.xfusioncorp.com/sarah/web_app.git',
                    branch: 'master'
                sh '''
                    sudo cp -r * /var/www/html/
                    sudo chown -R apache:apache /var/www/html/
                '''
            }
        }
    }
}
```

#### Explanation:  
This pipeline pulls code from Gitea and deploys it to the Apache web directory.

### Step 10: Allow sudo for sarah  

```bash
ssh tony@stapp01
echo "sarah ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/sarah
```

#### Explanation:  
This allows Jenkins (via sarah) to run deployment commands without password prompts.

### Step 11: Build the Pipeline  

```
Go to Job → Build Now
```

#### Explanation:  
This triggers the deployment process.

### Step 12: Verify Deployment  

```
Click App button
```

#### Explanation:  
The website should load directly from `/var/www/html`, confirming successful deployment.

---

## Key Learnings  
- Jenkins agents execute jobs on remote servers  
- Pipelines automate deployment  
- Git integration enables CI/CD  
- Java and permissions are mandatory for agent execution  
