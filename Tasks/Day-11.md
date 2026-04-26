# Day 11 – Install and Configure Tomcat Server

---

## Task Overview  
The Nautilus application development team recently finished the beta version of one of their Java-based applications, which they are planning to deploy on one of the app servers in Stratos DC. After an internal team meeting, they have decided to use the `tomcat` application server. Based on the requirements mentioned below complete the task:

- Install tomcat server on `App Server 2`.
- Configure it to run on port `6000`.
- There is a `ROOT.war` file on Jump host at location `/tmp`.

Deploy it on this `tomcat server` and make sure the webpage works directly on base URL i.e `curl http://stapp02:6000`.

---

## Step-by-Step Implementation  

### Step 1: Install Java Development Kit  

```bash
sudo yum install java-1.8.0-openjdk-devel -y
java -version
```
#### Explanation:  
The `yum install` command installs OpenJDK 8, which is required because Tomcat runs Java applications. 
- `-y` flag automatically confirms installation prompts.
- `java -version` command verifies that Java is installed and shows the installed version to ensure compatibility.

### Step 2: Create Tomcat User and Group  

```bash
sudo groupadd tomcat
sudo useradd -M -U -d /opt/tomcat -s /bin/nologin -g tomcat tomcat
```
#### Explanation:  
The `groupadd` command creates a system group named tomcat. 

The `useradd` command creates a dedicated tomcat user with no login shell (`/bin/nologin`) for security. 
- `-d /opt/tomcat` sets its home directory.
- `-g tomcat` assigns the user to the tomcat group.

### Step 3: Create Tomcat Directory  

```bash
sudo mkdir -p /opt/tomcat
```
#### Explanation:  
The `mkdir` command creates the Tomcat installation directory. 
- `-p` flag ensures the directory is created safely even if parent directories already exist.

### Step 4: Download and Extract Tomcat  

```bash
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz
sudo tar -xf apache-tomcat-9.0.80.tar.gz -C /opt/tomcat --strip-components=1
```
#### Explanation:  
The `wget` command downloads the Tomcat package from the official Apache repository. 

The `tar -xf` command extracts the archive.
- `-C /opt/tomcat` option extracts files into the target directory.
- `--strip-components=1` removes the top-level folder for a cleaner directory structure.

### Step 5: Set Permissions  

```bash
sudo chown -R tomcat:tomcat /opt/tomcat
```
#### Explanation:  
The `chown -R` command changes ownership of all files in `/opt/tomcat` to the tomcat user and group. This ensures the Tomcat service has proper read/write permissions.

### Step 6: Create Tomcat Service File  

```bash
sudo vi /etc/systemd/system/tomcat.service
```
#### Explanation:  
This command opens a new systemd service file where we define how Tomcat should start, stop, and run as a background service using the tomcat user.

### Step 7: Start and Enable Tomcat  

```bash
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat
sudo systemctl status tomcat
```
#### Explanation:  
The `systemctl daemon-reload` command reloads systemd configuration after adding a new service file. 

The `systemctl enable` command ensures Tomcat starts automatically on system boot. 

The `systemctl start` command launches the service immediately. 

The `systemctl status` command verifies whether Tomcat is running successfully.

### Step 8: Verify Default Access  

```bash
curl http://stapp02:8080
```
#### Explanation:  
The `curl` command sends an HTTP request to the server to verify that Tomcat is running and accessible on port 8080.

### Step 9: Change Port to 8086  

```bash
sudo vi /opt/tomcat/conf/server.xml
```
#### Explanation:  
This command opens the Tomcat configuration file. Changing the `<Connector port>` value updates the port on which Tomcat listens for incoming requests.

### Step 10: Backup Default ROOT Application  

```bash
cd /opt/tomcat/webapps
sudo mv ROOT ROOT.bak
```

#### Explanation:  
The `cd` command navigates to the webapps directory. 

The `mv` command renames the default ROOT application to avoid conflicts with the new application deployment.

### Step 11: Copy WAR File  

```bash
scp /tmp/ROOT.war steve@stapp02:/home/steve/
```
#### Explanation:  
The `scp` command securely copies the **ROOT.war** file from the jump host to the app server using SSH.

### Step 12: Deploy Application  

```bash
sudo unzip /home/steve/ROOT.war -d /opt/tomcat/webapps/ROOT
sudo chown -R tomcat:tomcat /opt/tomcat/webapps/ROOT
```
#### Explanation:  
The `unzip` command extracts the WAR file into the ROOT directory so it runs at the base URL. 

The `chown` command sets correct ownership so Tomcat can access and execute the application files.

### Step 13: Restart Tomcat  

```bash
sudo systemctl restart tomcat
```
#### Explanation:  
The `systemctl restart` command stops and starts Tomcat to apply new configuration changes and deploy the application.

### Step 14: Verify Application  

```bash
curl http://stapp02:6000
```
#### Explanation:  
This command verifies that Tomcat is running on port 6000 and the application is successfully deployed and accessible.

---

## Key Learnings  
- Tomcat requires Java runtime  
- Dedicated users improve security  
- WAR files deploy applications  
- ROOT directory maps to base URL  
- Restart is required after changes  
