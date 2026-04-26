# Day 14 – Linux Process Troubleshooting

---

## Task Overview  
The production support team of xFusionCorp Industries has deployed some of the latest monitoring tools to keep an eye on every service, application, etc. running on the systems. One of the monitoring systems reported about Apache service unavailability on one of the app servers in `Stratos DC`.

Identify the faulty app host and fix the issue. Make sure Apache service is up and running on all app hosts. They might not have hosted any code yet on these servers, so you don’t need to worry if Apache isn’t serving any pages. Just make sure the service is up and running. Also, make sure Apache is running on port `3002` on all app servers.

---

## Step-by-Step Implementation  

### Step 1: Check Apache Service Status  

```bash
sudo systemctl status httpd.service
```
#### Explanation:  
The `systemctl status` command manages system services using systemd and displays service state, logs, and errors. 
- `httpd.service` is the Apache service unit.

We run this command to identify if Apache is failed and view the reason.

### Step 2: View Detailed Logs  

```bash
sudo journalctl -u httpd.service -n 50 --no-pager
```
#### Explanation:  
The `journalctl` command reads system logs.  
- `-u httpd.service` filters logs for Apache  
- `-n 50` shows last 50 log entries  
- `--no-pager` prints output directly without scrolling  

We run this command to get detailed error messages like port conflicts.

### Step 3: Check Port Usage  

```bash
sudo netstat -tlnup | grep 3002
```
#### Explanation:  
The `netstat` command shows network connections and ports.  
- `-t` flag shows TCP connections  
- `-l` flag shows listening ports  
- `-n` flag shows numeric output  
- `-u` flag includes UDP  
- `-p` flag shows process ID and name  

The `grep 3002` filters output for port 3004.  

We run this to identify which process is using the port.

### Step 4: Alternative Port Check  

```bash
sudo ss -tlnup | grep 3002
```
#### Explanation:  
The `ss` command is a faster modern replacement for netstat.    

We run this to quickly confirm which service is occupying port 3004.

### Step 5: Identify Process Using Port  

```bash
sudo lsof -i :3002
```
#### Explanation:  
The `lsof` command lists open files and network connections.  
- `-i :3004` filters processes using port 3004  

We run this command to clearly identify the process (e.g., sendmail) and its PID.

### Step 6: Stop Conflicting Service  

```bash
sudo systemctl stop sendmail
```
#### Explanation:  
The `systemctl stop` command stops a running service.  
- `sendmail` is the conflicting service using port 3004  

We run this command to free the port required by Apache.

### Step 7: Verify Port is Free  

```bash
sudo netstat -tlnup | grep 3002
```
#### Explanation:  
This command checks if port 3004 is still in use. If no output is returned, it confirms the port is free.

### Step 8: Disable Sendmail  

```bash
sudo systemctl disable sendmail
```
#### Explanation:  
The `systemctl disable` command prevents service from starting at boot. We run this command to avoid future port conflicts after reboot.

### Step 9: Start Apache  

```bash
sudo systemctl start httpd
```
#### Explanation:  
The `systemctl start` command starts the Apache service. We run this after freeing the required port.

### Step 10: Verify Apache Status  

```bash
sudo systemctl status httpd.service
```
#### Explanation:  
This command confirms Apache is running successfully. Look for `active (running)` to ensure service health.

### Step 11: Confirm Apache Port Binding  

```bash
sudo netstat -tlnup | grep 3002
```
#### Explanation:  
This command verifies Apache is now listening on port 3002. We run this to confirm the service successfully bound to the port.

### Step 12: Enable Apache at Boot  

```bash
sudo systemctl enable httpd
```
#### Explanation:  
The `systemctl enable` command ensures Apache starts automatically at boot. We run this to maintain service availability after restart.

### Step 13: Test Apache Locally  

```bash
curl http://localhost:3002
```
#### Explanation:  
The `curl` command sends HTTP requests.  
- `localhost:3002` tests local server  

We run this to verify Apache is responding internally.

### Step 14: Test from Jump Host  

```bash
curl http://stapp01:3002
```
#### Explanation:  
This command tests external connectivity to Apache. We run this to ensure the service is accessible from other systems.

--- 

## Additional Verification Commands  

### Check Apache Configuration  

```bash
sudo httpd -t
```
#### Explanation:  
The `httpd -t` command tests Apache configuration syntax. We run this to ensure there are no configuration errors.

### View Error Logs  

```bash
sudo tail -f /var/log/httpd/error_log
```
#### Explanation:  
The `tail -f` command shows real-time log updates. We run this to monitor Apache errors during runtime.

### View Access Logs  

```bash
sudo tail -f /var/log/httpd/access_log
```
#### Explanation:  
This command shows incoming HTTP requests. We run this to verify traffic is reaching Apache.

### Check Apache Listening Ports  

```bash
sudo grep "^Listen" /etc/httpd/conf/httpd.conf
```
#### Explanation:  
The `grep` command searches for patterns in files.  
- `"^Listen"` matches lines starting with Listen  

We run this to confirm Apache is configured for port 3004.

### View All Listening Ports  

```bash
sudo ss -tlnup
```
#### Explanation:  
This command lists all active listening ports and processes. We run this to get a full view of network services.

### Check Apache Processes  

```bash
ps aux | grep httpd
```
#### Explanation:  
The `ps aux` command lists running processes.  
- `aux` shows all processes with details  
- `grep httpd` filters Apache processes  

We run this to confirm Apache worker processes are running.

---

## Key Learnings  
- Port conflicts are a common cause of service failure  
- journalctl provides detailed service logs  
- netstat/ss/lsof help identify port usage  
- systemctl manages services efficiently  
- Always verify both process and network level  
