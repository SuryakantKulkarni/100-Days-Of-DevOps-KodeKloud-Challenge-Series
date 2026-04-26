# Day 81 – Jenkins Multistage Pipeline

---

## Task Overview  
The development team of xFusionCorp Industries is working on to develop a new static website and they are planning to deploy the same on Nautilus App Server using Jenkins pipeline. They have shared their requirements with the DevOps team and accordingly we need to create a Jenkins pipeline job. Please find below more details about the task:

Click on the `Jenkins` button on the top bar to access the Jenkins UI. Login using username `admin` and password `Adm!n321`.

Similarly, click on the `Gitea` button on the top bar to access the Gitea UI. Login using username `sarah` and password `Sarah_pass123`.

There is a repository named `sarah/web` in Gitea that is already cloned on **App Server 1** under `/var/www/html` directory.

- Update the content of the file `index.html` under the same repository to `Welcome to xFusionCorp Industries` and push the changes to the origin into the `master` branch.

- Apache is already installed on the app server and is running on port `8080`.

- Add **App Server 1** as a Jenkins agent (slave) node: name `App Server 1`, label `stapp01`, remote root directory `/home/sarah/jenkins_agent`, launch via SSH with host `stapp01` and credentials for user `sarah`. Install `java-17-openjdk` on App Server 1 if needed.

- Create a Jenkins pipeline job named `deploy-job` (it must not be a `Multibranch pipeline` job) and pipeline should have two stages `Deploy` and `Test` ( names are case sensitive ). Configure these stages as per details mentioned below.

  - The `Deploy` stage should deploy the code from `web` repository under `/var/www/html` on **App Server 1**, as this is the document root of the app server.

  - The pipeline should run on the **App Server 1** node (e.g. use label `stapp01`).

  - The `Test` stage should just test if the app is working fine and website is accessible. Its up to you how you design this stage to test it out, you can simply add a `curl` command as well to run a curl against the LBR URL (`http://stlb01:8091`) to see if the website is working or not. Make sure this stage fails in case the website/app is not working or if the `Deploy` stage fails.

Click on the `App` button on the top bar to see the latest changes you deployed. Please make sure the required content is loading on the main URL `http://stlb01:8091` i.e there should not be a sub-directory like `http://stlb01:8091/web` etc.

Note:

- You might need to install some plugins and restart Jenkins service. So, we recommend clicking on `Restart Jenkins when installation is complete and no jobs are running` on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case, please make sure to refresh the UI page.

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

### Step 1: Update Website Code  

```bash
ssh tony@stapp01
sudo su - sarah

cd /var/www/html
vi index.html
```

Update content:
```
Welcome to xFusionCorp Industries
```

```bash
git add index.html
git commit -m "Update homepage"
git push origin master
```

#### Explanation:  
This step updates the website content and pushes it to the Git repository so Jenkins can deploy it.

### Step 2: Install Java  

```bash
sudo yum install -y java-17-openjdk
java -version
```

#### Explanation:  
Java is required for Jenkins agent to run on App Server.

### Step 3: Create Agent Directory  

```bash
mkdir -p /home/sarah/jenkins_agent
sudo chown -R sarah:sarah /home/sarah/jenkins_agent
```

#### Explanation:  
This directory is used by Jenkins agent to execute jobs on the server.

### Step 4: Add Jenkins Agent Node  

| Field | Value |
|------|------|
| Node Name | App Server 1 |
| Type | Permanent Agent |
| Remote Directory | /home/sarah/jenkins_agent |
| Labels | stapp01 |
| Launch Method | SSH |
| Host | stapp01 |
| Credentials | sarah (username/password) |
| Java Path | /usr/bin/java |

#### Explanation:  
This connects Jenkins to App Server 1 so pipeline runs directly on it.

### Step 5: Create Pipeline Job  

| Field | Value |
|------|------|
| Job Name | deploy-job |
| Type | Pipeline |

#### Explanation:  
Pipeline job is used to define multi-stage CI/CD workflow.

### Step 6: Add Pipeline Script  

```groovy
pipeline {
    agent { label 'stapp01' }

    stages {

        stage('Deploy') {
            steps {
                script {
                    sh '''
                    cd /var/www/html
                    git pull origin master
                    '''
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    sh '''
                    curl -f http://stlb01:8091
                    '''
                }
            }
        }
    }
}
```

#### Explanation:  
Deploy stage pulls latest code, and Test stage verifies the application using curl. The pipeline fails automatically if the test command fails.

### Step 7: Run Pipeline  

```
Build Now
```

#### Explanation:  
This triggers the pipeline and executes both stages sequentially.

### Step 8: Verify Deployment  

```bash
ssh sarah@stapp01

cat /var/www/html/index.html
curl http://localhost:8080/
```

#### Explanation:  
This confirms that the latest code is deployed and Apache is serving it.

### Step 9: Verify via Load Balancer  

```
http://stlb01:8091
```

#### Expected Output:
```
Welcome to xFusionCorp Industries
```

#### Explanation:  
This ensures the application is accessible externally through the load balancer.

---

## Key Learnings  
- Multistage pipelines separate deployment and testing  
- Jenkins agent executes jobs on remote server  
- curl -f ensures failure detection in pipelines  
- Git pull keeps deployment simple and consistent  
