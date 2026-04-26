# Day 12 - Linux Network Services

---

## Task Overview  
Our monitoring tool has reported an issue in `Stratos Datacenter`. One of our app servers has an issue, as its Apache service is not reachable on port 8087 (which is the Apache port). The service itself could be down, the firewall could be at fault, or something else could be causing the issue.

Use tools like `telnet`, `netstat`, etc. to find and fix the issue. Also make sure Apache is reachable from the jump host without compromising any security settings.

Once fixed, you can test the same using command `curl http://stapp01:8087` command from jump host.

> Note: Please do not try to alter the existing `index.html`code, as it will lead to task failure.

---

## Step-by-Step Implementation  

### Step 1: Connect to App Server  

```bash
ssh tony@stapp01
```
#### Explanation:  
The `ssh` command is used to securely connect to a remote server over the network. We run this command to access the app server and perform troubleshooting.

### Step 2: Check Apache Service Status

```bash
sudo systemctl status httpd
```
#### Explanation:  
The `systemctl status` command manages system services using systemd and checks whether the service is running, failed, or inactive. We run this command to identify errors such as port conflicts or startup failures.

### Step 3: Check Port Usage  

```bash
sudo netstat -tlnup | grep 8087
```
#### Explanation:  
The `netstat` command shows active network connections and listening ports.  
- `-t` flag shows TCP connections  
- `-l` flag shows listening ports  
- `-n` flag shows numeric IP/port (no DNS resolution)  
- `-u` flag includes UDP connections  
- `-p` flag shows process ID and program name  

The pipe `| grep 8087` filters output to show only entries using port 8087.  

We run this command to identify which service is using the port.

### Step 4: Identify Port Conflict  

| Port | Service | Issue |
|------|--------|------|
| 8087 | sendmail | Blocking Apache |

#### Explanation:  
The output shows sendmail is already listening on port 8087. Apache cannot bind to a port already in use, so the service fails to start.

### Step 5: Navigate to Sendmail Config  

```bash
cd /etc/mail
```
#### Explanation:  
The `cd` command changes the current directory.  
- `/etc/mail` is the directory where sendmail configuration files are stored  

We run this command to access configuration files for editing.

### Step 6: Backup Configuration  

```bash
sudo cp sendmail.mc sendmail.mc.bak
```
#### Explanation:  
The `cp` command copies files.  
- `sendmail.mc` is the original configuration file  
- `sendmail.mc.bak` is the backup copy  

We run this command to prevent data loss before making changes.

### Step 7: Edit Sendmail Config  

```bash
sudo vi /etc/mail/sendmail.mc
```
#### Explanation:  
The `vi` command opens a file in a text editor.  
- `/etc/mail/sendmail.mc` is the sendmail macro configuration file  

We run this command to modify the port used by sendmail.

### Step 8: Change Sendmail Port  

```
DAEMON_OPTIONS(`Port=1234,Addr=127.0.0.1, Name=MTA')dnl
```
#### Explanation:  
- `Port=1234` changes the listening port from 8087 to 1234  
- `Addr=127.0.0.1` restricts access to localhost  
- `Name=MTA` defines the mail transfer agent  
- `dnl` is a macro comment delimiter  

We modify this to free port 8087 for Apache.

### Step 9: Restart Sendmail  

```bash
sudo systemctl restart sendmail
```
#### Explanation:  
The `systemctl restart` command stops and starts the service. We run this command to apply the new configuration and release port 3000.

### Step 10: Start Apache  

```bash
sudo systemctl start httpd
```
#### Explanation:  
The `systemctl start` command starts a service. We run this command after resolving the port conflict.

### Step 11: Verify Apache Status  

```bash
sudo systemctl status httpd
```
#### Explanation:  
This command checks whether Apache is running successfully. It confirms that the service started without errors.

### Step 12: Verify Port Binding  

```bash
sudo netstat -tlnup | grep 8087
```
#### Explanation:  
This command verifies which service is listening on port 8087. We run this to confirm Apache (not sendmail) is using the port.

### Step 13: Test Locally  

```bash
curl http://localhost:8087
```
#### Explanation:  
The `curl` command sends an HTTP request to a server. We run this command to verify Apache is working internally.

### Step 14: Check Firewall Rules 

```bash
sudo iptables -L -n
```
#### Explanation:  
The `iptables` command displays firewall rules.  
- `-L` flag lists all rules  
- `-n` flag shows numeric output (no DNS lookup)  

We run this command to check if port 3000 is blocked.

### Step 15: Allow Port 8087

```bash
sudo iptables -I INPUT 4 -p tcp --dport 8087 -j ACCEPT
```
#### Explanation:  
The `iptables` command modifies firewall rules.  
- `-I INPUT 4` inserts rule at position 4 in INPUT chain  
- `-p tcp` matches TCP protocol  
- `--dport 8087` targets destination port 8087
- `-j ACCEPT` allows traffic  

We run this command to allow external access to Apache.

### Step 16: Test from Jump Host  

```bash
curl http://stapp01:8087
```
#### Explanation:  
The `curl` command tests HTTP connectivity from another server. We run this command to confirm Apache is accessible externally.

---

## Key Learnings  
- Port conflicts prevent services from starting  
- netstat helps identify active ports and processes  
- systemctl manages services  
- iptables controls network traffic  
- Always verify both local and external connectivity  
