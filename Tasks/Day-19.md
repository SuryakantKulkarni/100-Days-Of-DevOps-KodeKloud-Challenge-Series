# Day 19 – Install and Configure Web Application

---

## Task Overview  
xFusionCorp Industries is planning to host two static websites on their infra in Stratos Datacenter. The development of these websites is still in-progress, but we want to get the servers ready. Please perform the following steps to accomplish the task:

- Install `httpd` package and dependencies on `app server 3`.
  
- `Apache` should serve on port `8086`.
  
- There are two website's backups `/home/thor/ecommerce` and `/home/thor/cluster` on `jump_host`. Set them up on `Apache` in a way that official should work on the link `http://localhost:8086/ecommerce/` and cluster should work on link `http://localhost:8086/cluster/` on the mentioned app server.

- Once configured you should be able to access the website using `curl` command on the respective app server, i.e `curl http://localhost:8086/ecommerce/` and `curl http://localhost:8086/cluster/`.

---

## Step-by-Step Implementation  

### Step 1: Connect to App Server  

```bash
ssh banner@stapp03
```
#### Explanation:  
The `ssh` command is used to securely connect to a remote server over the network. We run this command to access **App Server 3** where Apache and websites will be configured.

### Step 2: Switch to Root User  

```bash
sudo su -
```
#### Explanation:  
The `sudo su -` command switches to the root user with full administrative privileges.  
- `sudo` provides elevated access  
- `su -` loads root environment variables  

We run this to perform installation and system-level configuration changes.

### Step 3: Install Apache Web Server  

```bash
dnf install httpd -y
```
#### Explanation:  
The `dnf install` command installs packages from system repositories.  
- `httpd` is the Apache web server package  
- `-y` flag automatically confirms installation prompts  

We run this to install Apache, which will serve the static web content.

### Step 4: Configure Apache Port  

```bash
vi /etc/httpd/conf/httpd.conf
```
#### Explanation:  
The `vi` command opens the Apache configuration file for editing.  
- `/etc/httpd/conf/httpd.conf` is the main configuration file  

We run this to modify the port Apache listens on.

### Step 5: Change Listening Port  

```
Listen 8086
```
#### Explanation:  
The `Listen` directive defines which port Apache will use to accept requests.  
- Changing from default `80` to `8086` allows custom port usage  

We update this to avoid conflicts and meet the task requirement.

### Step 6: Restart Apache Service  

```bash
systemctl restart httpd
```
#### Explanation:  
The `systemctl restart` command reloads Apache with the new configuration. This ensures the service starts listening on port 8086 and applies all changes properly.

### Step 7: Exit Root User  

```bash
exit
```
#### Explanation:  
The `exit` command switches back from root to the normal user (`banner`). We run this to continue file operations without unnecessary root usage.

### Step 8: Create Temporary Directories  

```bash
mkdir /tmp/ecommerce
mkdir /tmp/cluster
```
#### Explanation:  
The `mkdir` command creates directories on the filesystem.  
- `/tmp/ecommerce` and `/tmp/cluster` will temporarily store website files  

We run this to prepare locations for transferring files from the jump host.

---

## 🔹 Transfer Website Files  

### Step 9: Copy Ecommerce Website  

```bash
scp /home/thor/ecommerce/index.html banner@stapp03:/tmp/ecommerce
```
#### Explanation:  
The `scp` command securely copies files between systems over SSH.  
- Source: `/home/thor/ecommerce/index.html`  
- Destination: `/tmp/ecommerce` on target server  

We run this to transfer the ecommerce website file.

### Step 10: Copy Cluster Website  

```bash
scp /home/thor/cluster/index.html banner@stapp03:/tmp/cluster
```
#### Explanation:  
This command copies the cluster website file to the server. We run this so both website contents are available locally for deployment.

---

## 🔹 Deploy Websites  

### Step 11: Create Cluster Directory  

```bash
mkdir /var/www/html/cluster
```
#### Explanation:  
The `mkdir` command creates a directory inside Apache’s document root. We run this so the cluster site is accessible via `/cluster` URL path.

### Step 12: Move Cluster File  

```bash
sudo mv /tmp/cluster/index.html /var/www/html/cluster/
```
#### Explanation:  
The `mv` command moves files from one location to another.  
- `sudo` is required because `/var/www/html` needs root permissions  

We run this to deploy the cluster website content.

### Step 13: Create Ecommerce Directory  

```bash
mkdir /var/www/html/ecommerce
```
#### Explanation:  
Creates a directory for the ecommerce website inside Apache root. We run this to host multiple websites on the same server.

### Step 14: Move Ecommerce File  

```bash
sudo mv /tmp/ecommerce/index.html /var/www/html/ecommerce/
```
#### Explanation:  
Moves ecommerce site file into Apache document root. We run this so Apache can serve the ecommerce application correctly.

---

## 🔹 Verification  

### Step 15: Test Cluster Website  

```bash
curl http://localhost:8086/cluster/
```
#### Explanation:  
The `curl` command sends an HTTP request to the local server.  
- `localhost:8086` targets Apache  
- `/cluster/` accesses cluster directory  

We run this to confirm the cluster site is working correctly.

### Step 16: Test Ecommerce Website  

```bash
curl http://localhost:8086/ecommerce/
```
#### Explanation:  
This command tests the ecommerce website response. We run this to ensure both applications are properly deployed and accessible.

## Expected Output  

```
<h1>KodeKloud</h1>
<p>This is a sample page for our cluster website</p>
```

---

## Key Learnings  
- Apache serves content from `/var/www/html` by default  
- Custom ports allow running multiple services on same server  
- SCP enables secure file transfer between hosts  
- Directory-based hosting allows multiple apps under one server  
- curl helps quickly verify web service functionality  
