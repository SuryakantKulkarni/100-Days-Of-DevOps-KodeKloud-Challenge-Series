# Day 15 – Setup SSL for NGINX

---

## Task Overview  
The system admins team of `xFusionCorp Industries` needs to deploy a new application on `App Server 1` in `Stratos Datacenter`. They have some pre-requites to get ready that server for application deployment. Prepare the server as per requirements shared below:

- Install and configure `nginx` on `App Server 1`.

- On `App Server 1` there is a self signed SSL certificate and key present at location `/tmp/nautilus.crt` and `/tmp/nautilus.key`. Move them to some appropriate location and deploy the same in Nginx.

- Create an `index.html` file with content `Welcome!` under Nginx document root.
 
- For final testing try to access the `App Server 1` link (either hostname or IP) from `jump host` using curl command. For example `curl -Ik https://<app-server-ip>/`.

---

## Step-by-Step Implementation  

### Step 1: Connect to App Server  

```bash
ssh tony@stapp01
```
#### Explanation:  
The `ssh` command is used to securely connect to a remote server. We run this command to access the application server.

### Step 2: Switch to Root User  

```bash
sudo su
```
#### Explanation:  
The `sudo su` command switches to the root user.  
- `sudo` runs command with elevated privileges  
- `su` switches user to root  

We run this to get full administrative access for installation and configuration.

### Step 3: Install NGINX  

```bash
dnf install nginx -y
```
#### Explanation:  
The `dnf install` command installs packages from repositories.  
- `nginx` is the web server package  
- `-y` flag automatically confirms installation  

We run this command to install NGINX and its dependencies.

### Step 4: Start NGINX Service  

```bash
systemctl start nginx
```
#### Explanation:  
The `systemctl start` command starts a service. We run this to launch the web server.

### Step 5: Move SSL Certificate  

```bash
mv /tmp/nautilus.crt /etc/pki/tls/certs/
```
#### Explanation:  
The `mv` command moves files between directories.  
- `/tmp/nautilus.crt` is the certificate file  
- `/etc/pki/tls/certs/` is standard certificate directory  

We run this to store the SSL certificate in the correct location.

### Step 6: Move SSL Key  

```bash
mv /tmp/nautilus.key /etc/pki/tls/private/
```
#### Explanation:  
The `mv` command moves the private key file.  
- `/tmp/nautilus.key` is the SSL private key  
- `/etc/pki/tls/private/` is the secure key directory  

We run this to store the private key securely.

### Step 7: Open NGINX Config  

```bash
cd /etc/nginx
vi nginx.conf
```

#### Explanation:  
The `cd` command changes directory to NGINX config path.  
The `vi nginx.conf` command opens the configuration file for editing.  

We run this to modify server and SSL settings.

### Step 8: Configure HTTP Server  

```
server {
    listen 80;
    listen [::]:80;
    server_name <app-server-ip>;
    root /usr/share/nginx/html;
}
```
#### Explanation:  
- `listen 80` enables HTTP on port 80  
- `[::]:80` enables IPv6  
- `server_name` defines server IP/hostname  
- `root` defines document root  

We configure HTTP access for the server.

### Step 9: Configure HTTPS Server  

```
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name <app-server-ip>;

    ssl_certificate "/etc/pki/tls/certs/nautilus.crt";
    ssl_certificate_key "/etc/pki/tls/private/nautilus.key";
}
```
#### Explanation:  
- `listen 443 ssl` enables HTTPS  
- `http2` enables HTTP/2 protocol  
- `ssl_certificate` defines certificate path  
- `ssl_certificate_key` defines private key  

We configure encrypted communication using SSL.

### Step 10: Restart NGINX  

```bash
systemctl restart nginx
```
#### Explanation:  
The `systemctl restart` command reloads service configuration. We run this to apply SSL changes.

### Step 11: Check NGINX Status  

```bash
systemctl status nginx
```
#### Explanation:  
The `systemctl status` command shows service health. We run this to confirm NGINX is running properly.

### Step 12: Create Web Content  

```bash
cd /usr/share/nginx/html
rm -rf index.html
vi index.html
```
#### Explanation:  
- `cd` moves to document root  
- `rm -rf index.html` removes default file  
  - `-r` recursive  
  - `-f` force delete  
- `vi index.html` creates new file  

We run these commands to create custom webpage.

### Step 13: Add Content  

```
Welcome!
```
#### Explanation:  
This text becomes the default webpage content served by NGINX.

### Step 14: Test NGINX Config  

```bash
nginx -t
```
#### Explanation:  
The `nginx -t` command tests configuration syntax. We run this to ensure there are no errors before restart.

### Step 15: Test HTTPS from Jump Host  

```bash
curl -Ik https://stapp01
```
#### Explanation:  
The `curl` command sends HTTP requests.  
- `-I` fetches only headers  
- `-k` ignores SSL certificate validation  
- `https://stapp01` is target URL  

We run this to verify HTTPS is working.

### Expected Output  

```
HTTP/2 200
server: nginx
```

---

## Key Learnings  
- SSL encrypts communication between client and server  
- Certificates + private key enable HTTPS  
- Port 443 is used for secure traffic  
- nginx -t prevents config errors  
- curl -k is used for self-signed certificates  
