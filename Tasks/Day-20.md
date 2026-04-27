# Day 20 – Configure NGINX & PHP-FPM Using Unix Socket

---

## Task Overview  
The `Nautilus` application development team is planning to launch a new PHP-based application, which they want to deploy on `Nautilus` infra in `Stratos DC`. The development team had a meeting with the production support team and they have shared some requirements regarding the infrastructure. Below are the requirements they shared:

- Install `nginx` on `app server 1` , configure it to use port `8093` and its document `root` should be `/var/www/html`.
  
- Install `php-fpm` version `8.3` on `app server 1`, it must use the unix socket `/var/run/php-fpm/default.sock` (create the parent directories if don't exist).
  
- Configure `php-fpm` and `nginx` to work together.
  
- Once configured correctly, you can test the website using `curl http://stapp01:8093/index.php` command from jump host.

---

## Step-by-Step Implementation  

### Step 1: Connect to App Server  

```bash
ssh tony@stapp01
```
#### Explanation:  
The `ssh` command is used to securely connect to a remote server. We run this command to access App Server 1 where NGINX and PHP will be configured.

### Step 2: Switch to Root User  

```bash
sudo su -
```
#### Explanation:  
The `sudo su -` command switches to the root user with full privileges.  
- `sudo` gives administrative access  
- `su -` loads root environment variables  

We run this to install packages and modify system configuration files.

### Step 3: Install NGINX  

```bash
yum install nginx -y
```
#### Explanation:  
The `yum install` command installs packages from repositories.  
- `nginx` is the web server package  
- `-y` flag automatically confirms installation  

We run this to install NGINX, which will handle HTTP requests.

### Step 4: Configure NGINX Port and Root  

```bash
vi /etc/nginx/nginx.conf
```
#### Explanation:  
The `vi` command opens the main NGINX configuration file. We run this to modify server settings such as port and document root.

### Step 5: Update Server Block  

```
server {
    listen       8093;
    listen       [::]:8093;
    server_name  _;
    root         /var/www/html;
    index index.php index.html;
}
```

#### Explanation:  
- `listen 8093` sets custom port instead of default 80  
- `[::]:8093` enables IPv6 support  
- `root` defines document root directory  
- `index` sets default files to load  

We configure this so NGINX serves PHP and HTML content from correct location.

### Step 6: Restart NGINX  

```bash
systemctl restart nginx
```
#### Explanation:  
The `systemctl restart` command reloads the NGINX service. This ensures new configuration changes are applied and server starts listening on port 8093.

---

## 🔹 Install PHP-FPM 8.3  

### Step 7: Install Remi Repository  

```bash
dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm
```
#### Explanation:  
This command installs the Remi repository which provides updated PHP versions. We run this because default repositories may not include PHP 8.3.

### Step 8: Reset PHP Module  

```bash
dnf module reset php -y
```
#### Explanation:  
The `dnf module reset` command disables existing PHP module streams. We run this to avoid conflicts with older PHP versions.

### Step 9: Enable PHP 8.3 Module  

```bash
dnf module enable php:remi-8.3 -y
```
#### Explanation:  
This command enables PHP version 8.3 from Remi repository. We run this to ensure the required PHP version is used for installation.

### Step 10: Install PHP-FPM and Extensions  

```bash
dnf install -y php-fpm php-cli php-mysqlnd php-pgsql php-gd php-xml php-mbstring php-curl php-zip php-bcmath
```
#### Explanation:  
This command installs PHP-FPM and commonly used PHP extensions. These extensions enable database connectivity, XML handling, image processing, and API communication.

### Step 11: Verify PHP Version  

```bash
php -v
```
#### Explanation:  
The `php -v` command checks the installed PHP version. We run this to confirm PHP 8.2 is correctly installed.

---

## 🔹 Configure PHP-FPM  

### Step 12: Open PHP-FPM Config  

```bash
vi /etc/php-fpm.d/www.conf
```
#### Explanation:  
This file contains configuration for PHP-FPM worker processes. We run this to modify user, group, and socket settings.

### Step 13: Update User and Group  

```
user = nginx
group = nginx
```
#### Explanation:  
These settings define which user runs PHP-FPM processes. We change to `nginx` so both services share permissions properly.

### Step 14: Configure Unix Socket  

```
listen = /var/run/php-fpm/default.sock
```
#### Explanation:  
The `listen` directive defines how PHP-FPM accepts requests. We use a Unix socket instead of TCP for faster local communication.

### Step 15: Set Socket Permissions  

```
listen.owner = nginx
listen.group = nginx
listen.mode = 0660
```
#### Explanation:  
These settings define ownership and permissions of the socket file. They ensure NGINX can access the socket without permission issues after restart.

---

## 🔹 Configure NGINX with PHP-FPM  

### Step 16: Update NGINX Config  

```bash
vi /etc/nginx/nginx.conf
```
#### Explanation:  
We open NGINX configuration again to add PHP processing rules. This allows NGINX to forward PHP requests to PHP-FPM.

### Step 17: Add PHP Location Block  

```
location ~ \.php$ {
    fastcgi_pass unix:/var/run/php-fpm/default.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
}
```
#### Explanation:  
- `location ~ \.php$` matches PHP files  
- `fastcgi_pass` sends request to PHP-FPM socket  
- `SCRIPT_FILENAME` tells PHP which file to execute  

We configure this to enable PHP processing in NGINX.

### Step 18: Restart Services  

```bash
systemctl restart nginx
systemctl restart php-fpm
```
#### Explanation:  
These commands restart both services to apply all configuration changes. We run this to ensure NGINX and PHP-FPM are properly integrated.

---

## 🔹 Verification  

### Step 19: Test Application from Jump Host  

```bash
curl http://stapp01:8093/index.php
```
#### Explanation:  
The `curl` command sends an HTTP request to the server. We run this to verify PHP is processed correctly through NGINX and PHP-FPM.

## Expected Output  

```
Welcome to xFusionCorp Industries
```

---

## Key Learnings  
- PHP-FPM handles PHP execution efficiently  
- Unix sockets provide faster communication than TCP  
- NGINX acts as reverse proxy for PHP requests  
- Proper permissions are required for socket access  
- Modular PHP installation allows version control  
