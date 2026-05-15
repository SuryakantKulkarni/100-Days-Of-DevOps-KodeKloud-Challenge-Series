# Day 68 – Set Up Jenkins Server

---

## Task Overview  
The DevOps team at xFusionCorp Industries is initiating the setup of CI/CD pipelines and has decided to utilize Jenkins as their server. Execute the task according to the provided requirements:

- Install `Jenkins` on the jenkins server using the `apt` utility only, and start its `service`.
  
  - If you face a timeout issue while starting the Jenkins service, first check the service status with `service jenkins status`
    
  - Then review the logs in /var/log/jenkins/jenkins.log
    
2. Jenkin's admin user name should be `theadmin`, password should be `Adm!n321`, full name should be `Jim` and email should be `jim@jenkins.stratos.xfusioncorp.com`.

Note:

- To access the `jenkins` server, connect from the jump host using the `root` user with the password `S3curePass`.

- After Jenkins server installation, click the `Jenkins` button on the top bar to access the Jenkins UI and follow on-screen instructions to lcreate an admin user.  

---

## Step-by-Step Implementation  

### Step 1: Connect to Jenkins Server  
```bash
ssh root@jenkins
```
#### Explanation:  
The `ssh` command is used to securely connect to a remote server. The `root@jenkins` specifies the root user and Jenkins server hostname.

We run this command to access the Jenkins server with full administrative privileges.

### Step 2: Update Package List  
```bash
apt update -y
```
#### Explanation:  
The `apt update` command refreshes the package index from repositories.
- `-y` flag automatically confirms prompts.

We run this command to ensure the system has the latest package information before installing Jenkins.

### Step 3: Install Java (Dependency)  
```bash
apt install -y openjdk-17-jdk
```
#### Explanation:  
The `apt install` command installs required packages.
- `openjdk-17-jdk` is Java Development Kit required to run Jenkins.

We run this command because Jenkins is a Java-based application.

### Step 4: Verify Java Installation  
```bash
java -version
```
#### Explanation:  
The `java -version` command checks installed Java version. We run this command to ensure Java is installed correctly before proceeding.

### Step 5: Add Jenkins GPG Key 
```bash
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
```
#### Explanation:  
The `curl` command downloads data from a URL.
- `-fsSL` flags ensure silent and secure download.

The `tee` command saves the downloaded key to the specified file. 

This GPG key verifies the authenticity of Jenkins packages. We run this command to ensure packages are trusted before installation.

### Step 6: Add Jenkins Repository  
```bash
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
```
#### Explanation:  
The `echo` command writes repository details.

The `tee` command saves this into a new repository file. 

This step adds Jenkins official repository to the system. We run this command so apt can fetch Jenkins packages.

### Step 7: Install Jenkins  
```bash
apt update -y
apt install -y jenkins
```
#### Explanation:  
The first `apt update` refreshes package list after adding Jenkins repo.

The `apt install jenkins` installs Jenkins service and required files.

We run this command to install Jenkins on the server.

### Step 8: Start Jenkins Service  
```bash
service jenkins start
```
#### Explanation:  
The `service` command is used to manage system services.
- `start` option starts the Jenkins service.

We run this command to launch Jenkins server.

### Step 9: Check Jenkins Status  
```bash
service jenkins status
```
#### Explanation:  
The `service status` command shows whether Jenkins is running or not. We run this command to verify that Jenkins started successfully.

### Step 10: Troubleshoot (if service fails)  
```bash
cat /var/log/jenkins/jenkins.log | tail -50
```
#### Explanation:  
The `cat` command reads log file content.
- `tail -50` shows last 50 lines of logs.

We run this command to identify startup errors like Java issues, port conflicts, or permission problems.

### Step 11: Enable Jenkins on Boot  
```bash
systemctl enable jenkins
```
#### Explanation:  
The `systemctl enable` command ensures Jenkins starts automatically when the system reboots. We run this command to make Jenkins persistent.

### Step 12: Verify Jenkins Port  
```bash
netstat -tlnp | grep 8080
```
#### Explanation:  
The `netstat` command shows active network ports.
- `grep 8080` filters Jenkins default port.

We run this command to confirm Jenkins is listening on port 8080.

### Step 13: Get Initial Admin Password  
```bash
cat /var/lib/jenkins/secrets/initialAdminPassword
```
#### Explanation:  
This command reads the auto-generated Jenkins admin password. We run this command to unlock Jenkins UI during first login.

### Step 14: Access Jenkins UI  

Click the `Jenkins` button in the KodeKloud interface to open the Jenkins web UI in your browser.

  - You'll be presented with the **Unlock Jenkins** screen. Paste the initial admin password you retrieved in the previous step and click **Continue**.

### Step 15: Install suggested plugins 

On the **Customize Jenkins** page, click **Install suggested plugins**. Jenkins will automatically install a curated set of commonly used plugins including:
  - Git plugin for source control integration
  - Pipeline plugin for pipeline jobs
  - Credentials plugin for managing secrets
  - SSH Build Agents plugin for distributed builds
  - Many other essential plugins
    
The installation process may take 2-5 minutes depending on internet speed. If any plugin fails to install, you can click **Retry** or continue without it (you can install missing plugins later). Wait for all plugins to complete installation before proceeding.

### Step 16: Create the admin user account

After plugin installation completes, you'll see the **Create First Admin User** page. Fill in the required fields: 

| Field | Value |
|------|------|
| Username | theadmin |
| Password | Adm!n321 |
| Confirm Password | Adm!n321 |
| Full Name | Jim |
| Email | jim@jenkins.stratos.xfusioncorp.com |

Click **Save and Continue**. This creates the permanent administrator account that will replace the temporary initial admin password. 

### Step 17: Configure Jenkins URL and complete setup

On the **Instance Configuration** page, verify the Jenkins URL is correct (usually pre-populated with the server's address). 

Click **Save and Finish**. Then click **Start using Jenkins** to complete the setup wizard. You'll be redirected to the Jenkins dashboard, indicating successful installation and configuration. 

Jenkins is now ready to create jobs, configure pipelines, and integrate with version control systems.

### Step 15: Verify Jenkins Login  
```bash
curl -s -o /dev/null -w "%{http_code}" http://theadmin:Adm\!n321@localhost:8080/api/json
```
#### Explanation:  
The `curl` command sends HTTP request.
- `-w "%{http_code}"` prints response code.

We run this command to verify Jenkins authentication works.

---

## Best Practices  
- Always verify Java before Jenkins  
- Check logs for debugging  
- Enable service on boot  
- Secure admin credentials  

## Key Learnings  

- Jenkins setup requires Java  
- Logs help in troubleshooting  
- Services must be managed properly  
- CI/CD tools are core DevOps components  
