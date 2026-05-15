# Day 18 – Configure LAMP Server

---

## Task Overview  
xFusionCorp Industries is planning to host a `WordPress` website on their infra in `Stratos Datacenter`. They have already done infrastructure configuration - for example, on the storage server they already have a shared directory `/vaw/www/html` that is mounted on each app host under `/var/www/html` directory. Please perform the following steps to accomplish the task:

- Install `httpd`,`php` and its dependencies on all app hosts.
  
- Apache should serve on port `3003` within the apps.
  
- Install/Configure `MariaDB server` on DB Server.
  
- Create a database named `kodekloud_db2` and create a database user named `kodekloud_top` identified as password `your-password`. Further make sure this newly created user is able to perform all operation on the database you created.
  
- Finally you should be able to access the website on LBR link, by clicking on the `App` button on the top bar. You should see a message like `App is able to connect to the database using user kodekloud_top`.

---

## Step-by-Step Implementation  

### 🔹 Configure Application Servers (stapp01, stapp02, stapp03)

### Step 1: Connect to App Server  

```bash
ssh tony@stapp01
ssh steve@stapp02
ssh banner@stapp03
```
#### Explanation:  
The `ssh` command connects to a remote server securely. We run this to access the application server.

### Step 2: Switch to Root  

```bash
sudo su -
```
#### Explanation:  
The `sudo su -` command switches to root with login shell.  
- `sudo` gives admin privileges  
- `su -` loads root environment variables  

We run this for full administrative control.

### Step 3: Install PHP and Extensions  

```bash
dnf install php php-opcache php-gd php-curl php-mysqlnd -y
```
#### Explanation:  
The `dnf install` command installs packages.  
- `php` is core scripting language  
- `php-opcache` improves performance via caching  
- `php-gd` enables image processing  
- `php-curl` enables HTTP requests  
- `php-mysqlnd` allows DB connectivity  
- `-y` auto-confirms install  

We run this to enable dynamic web functionality.

### Step 4: Install Apache  

```bash
dnf install httpd -y
```
#### Explanation:  
The `dnf install` installs Apache web server.  
- `httpd` is Apache package  
- `-y` flag confirms automatically  

We run this to serve web content.

### Step 5: Start Apache  

```bash
systemctl start httpd
```
#### Explanation:  
The `systemctl start` command starts Apache service. We run this to launch web server.

### Step 6: Check Apache Status  

```bash
systemctl status httpd
```
#### Explanation:  
The `systemctl status` checks if Apache is running. We run this to verify service health.

### Step 7: Start PHP-FPM  

```bash
systemctl start php-fpm
```
#### Explanation:  
The `systemctl start` starts PHP FastCGI Process Manager.  
- `php-fpm` handles PHP request processing  

We run this for PHP execution.

### Step 8: Check PHP-FPM Status  

```bash
systemctl status php-fpm
```
#### Explanation:  
This command verifies PHP-FPM is running. We run this to ensure backend processing is active.

### Step 9: Configure Apache Port  

```bash
vi /etc/httpd/conf/httpd.conf
```
#### Explanation:  
The `vi` command opens Apache config file. We run this to modify port settings.

### Step 10: Change Port  

```
Listen 6100
```
#### Explanation:  
- `Listen` defines port Apache listens on  
- `6100` is custom port  

We change from default 80 to 6100.

### Step 11: Restart Apache  

```bash
systemctl restart httpd
```
#### Explanation:  
The `systemctl restart` reloads Apache with new config. We run this to apply port change.

### Step 12: Repeat on Other App Servers  

Repeat Step 1 - Step 11 on:
- stapp02  
- stapp03  

#### Explanation:  
All backend servers must have identical configuration for load balancing.

## 🔹 Configure Database Server (stdb01)

### Step 13: Connect to DB Server  

```bash
ssh peter@stdb01
```
#### Explanation:  
Connects to database server for DB setup.

### Step 14: Switch to Root  

```bash
sudo su -
```
#### Explanation:  
Switches to root for DB installation.

### Step 15: Install MariaDB  

```bash
dnf install mariadb mariadb-server -y
```
#### Explanation:  
- `mariadb` installs client tools  
- `mariadb-server` installs DB server  
- `-y` auto-confirm  

We run this to install database engine.

### Step 16: Enable and Start MariaDB  

```bash
systemctl enable mariadb
systemctl start mariadb
```
#### Explanation:  
- `enable` starts service on boot  
- `start` runs service immediately  

We run this to activate database.

### Step 17: Check MariaDB Status  

```bash
systemctl status mariadb
```
#### Explanation:  
Verifies database service is running.

### Step 18: Open MySQL Shell  

```bash
mysql -u root
```
#### Explanation:  
The `mysql` command opens DB shell.  
- `-u root` logs in as root user  

We run this to execute SQL queries.

### Step 19: Create Database  

```sql
CREATE DATABASE kodekloud_db2;
```
#### Explanation:  
Creates a new database for application use.

### Step 20: Create User & Grant Access  

```sql
GRANT ALL PRIVILEGES ON kodekloud_db2.* TO 'kodekloud_top'@'%' IDENTIFIED BY 'your-password';
```
#### Explanation:  
- `GRANT ALL PRIVILEGES` gives full access  
- `kodekloud_db2.*` means all tables in DB  
- `'user'@'%'` allows access from any host  
- `IDENTIFIED BY` sets password  

We run this to allow app servers to connect.

### Step 21: Apply Privileges  

```sql
FLUSH PRIVILEGES;
```
#### Explanation:  
Reloads privilege tables. We run this to apply changes immediately.

### Step 22: Verify Users  

```sql
SELECT user, host FROM mysql.user;
```
#### Explanation:  
Displays all DB users and allowed hosts. We run this to confirm user creation.

---

## Key Learnings  
- LAMP = Linux + Apache + MariaDB + PHP  
- PHP connects web apps to database  
- Apache port customization is common in multi-server setups  
- GRANT controls DB access  
- '%' allows remote DB connections  
