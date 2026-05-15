# Day 71 – Configure Jenkins Job for Package Installation

---

## Task Overview  
Some new requirements have come up to install and configure some packages on the Nautilus infrastructure under Stratos Datacenter. The Nautilus DevOps team installed and configured a new Jenkins server so they wanted to create a Jenkins job to automate this task. Find below more details and complete the task accordingly:

- Access the Jenkins UI by clicking on the `Jenkins` button in the top bar. Log in using the credentials: username `admin` and password `Adm!n321`.

- Create a new Jenkins job named `install-packages` and configure it with the following specifications:

  - Add a string parameter named `PACKAGE`.

  - Configure the job to install a package specified in the `$PACKAGE` parameter on the `storage server` (Stratos Datacenter).

  - Build the job at least once (e.g. with parameter `PACKAGE=vim-enhanced`) so the package is installed on the Storage server and can be verified.

`Note:`

1. Ensure to install any required plugins and restart the Jenkins service if necessary. Opt for `Restart Jenkins when installation is complete and no jobs are running` on the plugin installation/update page. Refresh the UI page if needed after restarting the service.

2. Verify that the Jenkins job runs successfully on repeated executions to ensure reliability.

3. Capture screenshots of your configuration for documentation and review purposes. Alternatively, use screen recording software like `loom.com` for comprehensive documentation and sharing. 

---

## Step-by-Step Implementation  

### Step 1: Access Jenkins UI  
- Open the Jenkins web interface by clicking the Jenkins button in the top bar.
- Enter the administrator credentials to access the Jenkins dashboard. 

```
Username: admin  
Password: Adm!n321
```
#### Explanation:  
We log into Jenkins using admin credentials to configure jobs and system settings.

### Step 2: Install Required Plugins  

Navigate to:

```
Manage Jenkins → Manage Plugins → Available
```

Install:
- SSH Plugin  
- SSH Credentials Plugin  
- Publish Over SSH

Click **Install** → then select **Restart Jenkins when installation is complete and no jobs are running**. Refresh page after restart.

#### Explanation:  
Plugins extend Jenkins functionality. SSH plugins allow Jenkins to connect and execute commands on remote servers securely.

### Step 3: Add SSH Credentials  

Navigate to:

```
Manage Jenkins → Credentials → System → Global → Add Credentials
```

Fill the configure credential details:

| Field | Value |
|------|------|
| Kind | Username with password |
| Scope | Global |
| Username | natasha |
| Password | Bl@kW |
| ID | storage-server-creds |
| Description | Storage Server SSH Credentials |

#### Explanation:  
The credentials store securely saves login details. We use this to authenticate Jenkins with the storage server.

Storage server credentials for Stratos DC — user is `natasha`, server is `ststor01`.

### Step 4: Configure SSH Remote Host  

Navigate to:

```
Manage Jenkins → Configure System → SSH Servers section → Click Add
```

Add SSH site with:

| Field | Value |
|------|------|
| Name | storage-server | 
| Username | natasha | 
| Hostname | ststor01 |
| Remote Directory | / |

Click **Advanced** → Check `Use password authentication`

| Field | Value |
|------|------|
| Password | Bl@kW |
| Port | 22 |
| Credentials | storage-server-creds |

Click **Test Connection → Success → Save**

#### Explanation:  
This step registers the storage server as a remote target. Jenkins will use this configuration to run commands remotely.

### Step 5: Create Jenkins Job  

Navigate to:

```
Dashboard → New Item
```

| Field | Value |
|------|------|
| Name | install-packages |
| Type | Freestyle Project |

Click **OK**

#### Explanation:  
A freestyle job allows simple automation tasks.

### Step 6: Add String Parameter  

Enable:

```
This project is parameterized
```

Click **Add Parameter** → **String Parameter**

Add:

| Field | Value |
|------|------|
| Name | PACKAGE |
| Default | vim-enhanced |

#### Explanation:  
This creates a dynamic input parameter. The value will be passed as `$PACKAGE` during execution.

### Step 7: Add Build Step  

Navigate:

```
Build → Add build step → Send files or execute commands over SSH
```

Add: 

| Field | Value |
|------|------|
| SSH Server | storage-server |
| Exec command | `sudo yum install -y $PACKAGE` |

Click **Save**

#### Explanation:  
The command installs the package using yum. `$PACKAGE` is replaced by the user input during build.

### Step 8: Build the Job  

To execute:

```
Dashboard > install-packages > Build with Parameters
```

| Field | Value |
|------|------|
| PACKAGE | vim-enhanced |

Click **Build**

#### Explanation:  
This triggers the Jenkins job with user input.

### Step 9: Verify Build Output  

Open:

```
Build → Console Output
```

#### Expected Output:
```
Started by user admin
Running as SYSTEM
Building in workspace /var/lib/jenkins/workspace/install-packages
SSH: Connecting from host [jenkins.stratos.xfusioncorp.com]
SSH: Connecting with configuration [storage-server]...
SSH: EXEC: completed after 8,803 ms
SSH: Disconnecting configuration (storage-server]...
SSH: Transferred 8 file(s)
Build step 'Send files or execute commands over SSH changed build result to SUCCESS
Finished: SUCCESS
```

#### Explanation:  
Console output shows execution logs. `SUCCESS` indicates successful installation.

### Step 10: Verify on Storage Server 
```bash
ssh natasha@ststor01
rpm -qa | grep vim-enhanced
```
#### Explanation:  
The `rpm -qa` command lists installed packages. We verify that the package was installed correctly.---

---

## Best Practices  
- Use credentials store for security  
- Always test jobs after creation  
- Use parameterized jobs for flexibility  
- Validate results on target server  

## Key Learnings  
- Jenkins can automate remote operations  
- Parameterized jobs improve reusability  
- SSH integration is key for infrastructure automation  
- CI/CD pipelines often include package management  
