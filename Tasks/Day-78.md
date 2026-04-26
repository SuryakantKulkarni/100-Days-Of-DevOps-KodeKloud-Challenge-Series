# Day 78 – Jenkins Conditional Pipeline

---

## Task Overview  
The development team of xFusionCorp Industries is working on to develop a new static website and they are planning to deploy the same on Nautilus App Server using Jenkins pipeline. They have shared their requirements with the DevOps team and accordingly we need to create a Jenkins pipeline job. Please find below more details about the task:

Click on the `Jenkins` button on the top bar to access the Jenkins UI. Login using username `admin` and password `Adm!n321`.

Similarly, click on the `Gitea` button on the top bar to access the Gitea UI. Login using username `sarah` and password `Sarah_pass123`. There under user `sarah` you will find a repository named `web_app` that is already cloned on **App Server 1** under `/var/www/html`. sarah is a developer who is working on this repository.

- Add a slave node named `App Server 1`. It should be labeled as `stapp01` and its remote root directory should be `/home/sarah/jenkins_agent` (the repository is cloned under `/var/www/html`).

- We have already cloned repository on **App Server 1** under `/var/www/html`.

- Apache is already installed on the app server and is running on port `8080`.

- Create a Jenkins pipeline job named `nautilus-webapp-job` (it must not be a `Multibranch pipeline`) and configure it to:

  - Add a string parameter named `BRANCH`.

  - It should conditionally deploy the code from `web_app` repository under `/var/www/html` on **App Server 1**, as this is the document root of the app server. The pipeline should have a single stage named `Deploy` ( which is case sensitive ) to accomplish the deployment.

  - The pipeline should be conditional, if the value `master` is passed to the `BRANCH` parameter then it must deploy the `master` branch, on the other hand if the value `feature` is passed to the `BRANCH` parameter then it must deploy the `feature` branch.

LB server is already configured. You should be able to see the latest changes you made by clicking on the `App` button. Please make sure the required content is loading on the main URL `https://<LBR-URL>` i.e there should not be a sub-directory like `https://<LBR-URL>/web_app` etc.

`Note:`

- You might need to install some plugins and restart Jenkins service. So, we recommend clicking on `Restart Jenkins when installation is complete and no jobs are running` on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case, please make sure to refresh the UI page.

- For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.---

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

id sarah || sudo useradd sarah
echo "sarah:Sarah_pass123" | sudo chpasswd

sudo mkdir -p /home/sarah/jenkins_agent
sudo chown -R sarah:sarah /home/sarah/jenkins_agent

sudo chown -R sarah:sarah /var/www/html
sudo chmod -R 755 /var/www/html

echo "sarah ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/sarah
sudo chmod 440 /etc/sudoers.d/sarah

sudo yum install -y java-17-openjdk
```

#### Explanation:  
This step prepares the server by creating the sarah user, setting permissions, enabling sudo access, and installing Java required for Jenkins agent.

### Step 2: Install Required Plugins  

| Plugin |
|-------|
| SSH Build Agents |
| Git |
| Pipeline |

#### Explanation:  
These plugins enable Jenkins to connect to remote servers, fetch code, and run pipelines.

### Step 3: Add SSH Credentials  

| Field | Value |
|------|------|
| Kind | Username with password |
| Username | sarah |
| Password | Sarah_pass123 |
| ID | sarah-appserver1 |

#### Explanation:  
This credential allows Jenkins to connect to App Server 1 via SSH.

### Step 4: Add Gitea Credentials  

| Field | Value |
|------|------|
| Kind | Username with password |
| Username | sarah |
| Password | Sarah_pass123 |
| ID | gitea-sarah-creds |

#### Explanation:  
This credential allows Jenkins to clone the repository from Gitea.

### Step 5: Create Jenkins Agent Node  

| Field | Value |
|------|------|
| Node Name | App Server 1 |
| Type | Permanent Agent |
| Remote Directory | /home/sarah/jenkins_agent |
| Labels | stapp01 |
| Launch Method | Launch agents via SSH |
| Host | stapp01 |
| Credentials | sarah-appserver1 |
| Java Path | /usr/bin/java |

#### Explanation:  
This connects Jenkins to App Server 1 so pipeline jobs can run on it.

### Step 6: Create Pipeline Job  

| Field | Value |
|------|------|
| Job Name | nautilus-webapp-job |
| Type | Pipeline |

#### Explanation:  
Pipeline job is required to automate deployment using code.

### Step 7: Add Parameter  

| Field | Value |
|------|------|
| Parameter Type | String |
| Name | BRANCH |
| Default Value | master |

#### Explanation:  
This parameter allows selecting which branch to deploy.

### Step 8: Configure Pipeline Script  

```groovy
pipeline {
    agent {
        label 'stapp01'
    }
    parameters {
        string(name: 'BRANCH', defaultValue: 'master', description: 'Enter master or feature')
    }
    stages {
        stage('Deploy') {
            steps {
                script {
                    if (params.BRANCH == 'master') {
                        git credentialsId: 'gitea-sarah-creds',
                            url: '<GITEA-URL>',
                            branch: 'master'
                    } else if (params.BRANCH == 'feature') {
                        git credentialsId: 'gitea-sarah-creds',
                            url: '<GITEA-URL>',
                            branch: 'feature'
                    } else {
                        error "Invalid BRANCH: ${params.BRANCH}"
                    }
                }
                sh '''
                    sudo rm -rf /var/www/html/*
                    sudo rm -rf /var/www/html/.[^.]*

                    sudo cp -rf . /var/www/html/
                    sudo rm -rf /var/www/html/.git

                    sudo chown -R apache:apache /var/www/html/
                    sudo chmod -R 755 /var/www/html/
                '''
            }
        }
    }
}
```

#### Explanation:  
This pipeline checks the selected branch and deploys the correct code to the web server directory.

### Step 9: Build Master Branch  

```
Build with Parameters → BRANCH=master
```

#### Explanation:  
This deploys the master branch code to the server.

### Step 10: Build Feature Branch  

```
Build with Parameters → BRANCH=feature
```

#### Explanation:  
This deploys the feature branch code to the server.

### Step 11: Verify Deployment  

```bash
ssh tony@stapp01
ls -la /var/www/html/
cat /var/www/html/index.html
```

#### Explanation:  
This confirms that correct files are deployed and website content is updated.

---

## Key Learnings  
- Parameters control dynamic pipeline behavior  
- Conditional logic enables multi-branch deployment  
- Clean deployment requires removing old files  
- Jenkins agents execute jobs on remote servers  
