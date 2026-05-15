# Day 74 – Jenkins Database Backup Job

---

## Task Overview  
There is a requirement to create a Jenkins job to automate the database backup. Below you can find more details to accomplish this task:

Click on the `Jenkins` button on the top bar to access the Jenkins UI. Login using username `admin` and password `Adm!n321`.

- Create a Jenkins job named `database-backup`.

- Configure it to take a database dump of the `kodekloud_db01` database present on the **App Server 1 (stapp01)** in `Stratos Datacenter`, the database user is `kodekloud_roy` and password is `asdfgdsd`.

- The dump should be named in `db_$(date +%F).sql` format, where `date +%F` is the current date.

- Copy the `db_$(date +%F).sql` dump to the **Storage Server (ststor01)** under location `/home/natasha/db_backups`.

- Further, schedule this job to run periodically at `*/10 * * * *`(please use this exact schedule format).

`Note:`

- You might need to install some plugins and restart Jenkins service. So, we recommend clicking on `Restart Jenkins when installation is complete and no jobs are running` on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case please make sure to refresh the UI page.

- Please make sure to define you cron expression like this `*/10 * * * *` (this is just an example to run job every 10 minutes).

- For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.

---

## Step-by-Step Implementation  

### Step 1: Login to Jenkins  

Login using:

```
Username: admin  
Password: Adm!n321
```

#### Explanation:  
We log into Jenkins as an admin user because only admin has permission to install plugins, configure servers, and create jobs.

### Step 2: Install Required Plugin  

Go to:

```
Manage Jenkins → Manage Plugins → Available
```

Search and install:

```
Publish Over SSH
```

#### Explanation:  
This plugin allows Jenkins to connect to remote servers using SSH and execute commands or transfer files securely.

### Step 3: Configure SSH Servers  

Go to:

```
Manage Jenkins → Configure System → Publish Over SSH
```

#### Add App Server  

| Field | Value |
|------|------|
| Name | appserver1 |
| Hostname | stapp01 |
| Username | tony |
| Remote Directory | /tmp |

Click **Advanced → Use password → enter password → Test Configuration**

#### Add Storage Server  

| Field | Value |
|------|------|
| Name | storage-server |
| Hostname | ststor01 |
| Username | natasha |
| Remote Directory | /home/natasha/db_backups |

Click **Test Configuration → Save**

#### Explanation:  
This step stores SSH connection details inside Jenkins so it can log into both servers without manual login during job execution.

### Step 4: Create Jenkins Job  

Go to:

```
Dashboard → New Item
```

| Field | Value |
|------|------|
| Name | database-backup |
| Type | Freestyle Project |

Click **OK**

#### Explanation:  
A freestyle job is used because we need to run shell commands without creating a full pipeline script.

### Step 5: Configure Schedule  

Scroll to **Build Triggers**

Enable:

```
Build periodically
```

Add:

```bash
*/10 * * * *
```

#### Explanation:  
This cron expression runs the job every 10 minutes, which ensures frequent backups with minimal data loss risk.

### Step 6: Add Build Step (Create Backup)  

Go to:

```
Build → Add build step → Send files or execute commands over SSH
```

Select:
```
SSH Server: appserver1
```

Add command:

```bash
mkdir -p /tmp/db-backup

mysqldump -u kodekloud_roy -pasdfgdsd kodekloud_db01 > /tmp/db-backup/db_$(date +%F).sql

ls -lh /tmp/db-backup/
```

#### Explanation:  
The `mkdir` command creates a directory for storing the backup temporarily.  

The `mysqldump` command exports the database into a `.sql` file.  
- `date +%F` adds the current date to the filename.
  
The `ls` command verifies that the backup file is created successfully.

### Step 7: Add Build Step (Transfer Backup)  

Add another step:

```
SSH Server: storage-server
```

```bash
scp -o StrictHostKeyChecking=no tony@stapp01:/tmp/db-backup/db_$(date +%F).sql /home/natasha/db_backups/

ls -lh /home/natasha/db_backups/
```

#### Explanation:  
The `scp` command securely copies the backup file from the App Server to the Storage Server.  
- `StrictHostKeyChecking=no` option avoids manual confirmation during first connection.  

The `ls` command confirms that the file has been copied successfully.

## ⚠️ Fix Error (Status 255)

#### Problem:  
SSH failed because the Storage Server could not access the App Server.

---

### Solution  

```bash
ssh natasha@ststor01

ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""

ssh-copy-id tony@stapp01

ssh tony@stapp01 "echo success"
```

#### Explanation:  
We generate an SSH key on the Storage Server and copy it to the App Server. This allows passwordless communication, which is required for automation.

### Step 8: Run Job  

Click:

```
Build Now
```

#### Explanation:  
This step manually runs the job to verify that backup creation and transfer are working correctly.

### Step 9: Verify Backup  

```bash
ssh natasha@ststor01
ls -lh /home/natasha/db_backups/
```

#### Explanation:  
This command checks whether the backup file is present on the Storage Server and confirms successful execution.

---

## Key Learnings  
- Jenkins can automate database backups easily  
- SSH enables secure communication between servers  
- Cron scheduling ensures regular backups  
- Backup verification is critical in production  
