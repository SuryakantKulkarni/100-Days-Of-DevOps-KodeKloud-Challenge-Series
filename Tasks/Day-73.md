# Day 73 – Configure Jenkins User Access

---

## Task Overview  
The devops team of xFusionCorp Industries is working on to setup centralised logging management system to maintain and analyse server logs easily. Since it will take some time to implement, they wanted to gather some server logs on a regular basis. At least one of the app servers is having issues with the Apache server. The team needs Apache logs so that they can identify and troubleshoot the issues easily if they arise. So they decided to create a Jenkins job to collect logs from the server. Please create/configure a Jenkins job as per details mentioned below:

Click on the `Jenkins` button on the top bar to access the Jenkins UI. Login using username `admin` and password `Adm!n321`

- Create a Jenkins jobs named `copy-logs`.

- Configure it to periodically build `every 9 minutes` to copy the Apache logs (both `access_log` and `error_logs`) from **App Server 1** (stapp01) from default logs location) to location `/usr/src/itadmin` on Storage Server.

- Build the job at least once so that the logs are copied and can be verified.
  
`Note:`

1. You might need to install some plugins and restart Jenkins service. So, we recommend clicking on `Restart Jenkins when installation is complete and no jobs are running` on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case please make sure to refresh the UI page.

2. Please make sure to define you cron expression like this `*/10 * * * *` (this is just an example to run job every 10 minutes).

3. For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.

---

## Step-by-Step Implementation  

---

### Step 1: Install Required Plugin  

Go to:

```
Manage Jenkins → Manage Plugins → Available
```

Search and install:
```
Publish Over SSH
```

#### Explanation:  
This plugin allows Jenkins to securely connect to remote servers and transfer files over SSH, which is required for copying logs.

### Step 2: Configure SSH Server (Storage Server)  
Go to:

```
Manage Jenkins → Configure System → Publish over SSH
```

Add:

| Field | Value |
|------|------|
| Name | storage-server |
| Hostname | ststor01 |
| Username | natasha |
| Remote Directory | /usr/src/itadmin | 

Click **Test Configuration → Success → Save**

#### Explanation:  
This configuration registers the storage server inside Jenkins so that it can receive files from jobs.

### Step 3: Ensure Access to App Server  
We will use SSH inside the Jenkins job to fetch logs from App Server 1.

#### Explanation:  
Jenkins must be able to connect to the app server to read log files, so SSH access is required for automation.

### Step 4: Create Jenkins Job  
Go to:

```
Dashboard → New Item
```

| Field | Value |
|------|------|
| Name | copy-logs |
| Type | Freestyle Project |

#### Explanation:  
A freestyle job allows us to run custom shell commands and define post-build actions.

### Step 5: Configure Build Trigger  
Enable:

```
Build periodically
```

Add cron:

```bash
*/9 * * * *
```

#### Explanation:  
This schedule runs the job every 9 minutes automatically.

### Step 6: Add Build Step (Fetch Logs)  
```bash
sshpass -p 'Ir0nM@n' ssh -o StrictHostKeyChecking=no tony@stapp01 \
  "sudo cat /var/log/httpd/access_log" > access_log

sshpass -p 'Ir0nM@n' ssh -o StrictHostKeyChecking=no tony@stapp01 \
  "sudo cat /var/log/httpd/error_log" > error_log
```

#### Explanation:  
The `sshpass` command allows non-interactive SSH login using a password, the `ssh` command connects to the app server, and `cat` reads log files which are saved locally in the Jenkins workspace.

### Step 7: Add Post-Build Action (Send Logs)  

- Action: **Send build artifacts over SSH**  
- SSH Server: `storage-server`  
- Source files:  
```
access_log, error_log
```
- Remote directory:  
```
/usr/src/itadmin
```

#### Explanation:  
This step transfers the generated log files from Jenkins to the storage server using SSH.

### Step 8: Save Job  
Click **Save**

#### Explanation:  
This stores the job configuration so Jenkins can execute it.

### Step 9: Run Job  
Click:

```
Build Now
```

#### Explanation:  
This manually triggers the job to verify that everything is working correctly.

### Step 10: Verify Output  

Check Jenkins console:
```
Finished: SUCCESS
```

Verify on storage server:
```bash
ssh natasha@ststor01
ls -lh /usr/src/itadmin/
```

#### Explanation:  
These commands confirm that logs were successfully transferred and stored.

---

## Security Best Practices  
- Avoid giving admin access to all users  
- Follow principle of least privilege  
- Disable anonymous access  
- Regularly review user permissions  

## Key Learnings  
- Jenkins security is critical in CI/CD environments  
- Proper user roles prevent misuse and errors  
- Matrix security offers detailed access control  
- Testing access ensures correct configuration  
