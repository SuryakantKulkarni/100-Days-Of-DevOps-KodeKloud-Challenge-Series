# Day 16 – Install and Configure NGINX as Load Balancer

---

## Task Overview  
Day by day traffic is increasing on one of the websites managed by the `Nautilus` production support team. Therefore, the team has observed a degradation in website performance. Following discussions about this issue, the team has decided to deploy this application on a high availability stack i.e on `Nautilus` infra in `Stratos DC`. They started the migration last month and it is almost done, as only the LBR server configuration is pending. Configure LBR server as per the information given below:

- Install `nginx` on `LBR` server.

- Configure load-balancing with the an `http` context making use of all `App Servers`. Ensure that you update only the main Nginx configuration file located at `/etc/nginx/nginx.conf`.

- Make sure you do not update the apache port that is already defined in the apache configuration on all app servers, also make sure apache server is up and running on all app servers

- Once done, you can access the website using `StaticApp` button on the top bar

---

## Step-by-Step Implementation  

### Step 1: Connect to Load Balancer Server  

```bash
ssh loki@stlb01
```
#### Explanation:  
The `ssh` command is used to securely connect to a remote system. We run this command to access the load balancer server.

### Step 2: Switch to Root User  

```bash
sudo su
```
#### Explanation:  
The `sudo su` command switches to the root user.  
- `sudo` provides elevated privileges  
- `su` switches user to root  

We run this to perform installation and configuration tasks.

### Step 3: Install NGINX  

```bash
dnf install nginx -y
```
#### Explanation:  
The `dnf install` command installs packages from repositories.  
- `nginx` is the load balancer software  
- `-y` auto-confirms installation  

We run this command to install NGINX.

### Step 4: Start and Enable NGINX  

```bash
systemctl enable nginx
systemctl start nginx
```
#### Explanation:  
The `systemctl enable` command enables service at boot.  
The `systemctl start` command starts service immediately.  

We run these commands to ensure NGINX is always running.

### Step 5: Check Apache Port on App Server  

```bash
ssh tony@stapp01
```

#### Explanation:  
This command connects to App Server 1 to verify Apache configuration.

```bash
sudo ss -tlnup | grep httpd
```

#### Explanation:  
The `ss` command shows socket statistics.  
- `-t` TCP connections  
- `-l` listening ports  
- `-n` numeric output  
- `-u` UDP sockets  
- `-p` process info  

The `grep httpd` filters Apache process. We run this to find Apache port (5001).

### Step 6: Verify Same Port on All Servers  

Repeat on stapp02 and stapp03  

```bash
sudo ss -tlnup | grep httpd
```
#### Explanation:  
We run this on all app servers to confirm Apache is listening on the same port (5001).

### Step 7: Open NGINX Config  

```bash
vi /etc/nginx/nginx.conf
```
#### Explanation:  
The `vi` command opens the NGINX configuration file.  
- `/etc/nginx/nginx.conf` is the main config file  

We run this to configure load balancing.

### Step 8: Configure Upstream Servers  

```
upstream appservers {
    server stapp01:5001;
    server stapp02:5001;
    server stapp03:5001;
}
```
#### Explanation:  
- `upstream` defines backend server group  
- `appservers` is group name  
- `server host:port` defines backend targets  

We define all app servers for load balancing.

### Step 9: Configure Reverse Proxy  

```
location / {
    proxy_pass http://appservers;
}
```
#### Explanation:  
- `location /` matches all incoming requests  
- `proxy_pass` forwards requests to upstream  
- `http://appservers` refers to upstream block  

We configure NGINX to distribute traffic to backend servers.

### Step 10: Test NGINX Configuration  

```bash
nginx -t
```
#### Explanation:  
The `nginx -t` command validates configuration syntax. We run this to ensure no errors before applying changes.

### Step 11: Restart NGINX  

```bash
systemctl restart nginx
```
#### Explanation:  
The `systemctl restart` command reloads service with new config. We run this to apply load balancing configuration.

### Step 12: Check NGINX Status  

```bash
systemctl status nginx
```
#### Explanation:  
This command verifies NGINX is running properly. We run this to confirm service health.

### Step 13: Test Load Balancer  

```bash
curl http://stlb01
```
#### Explanation:  
The `curl` command sends HTTP request to load balancer. We run this to verify traffic is served via backend servers.

---

## Key Learnings  
- Load balancer distributes traffic across servers  
- Upstream block defines backend pool  
- proxy_pass forwards requests  
- ss command helps identify service ports  
- nginx -t prevents configuration errors  
