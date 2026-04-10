# Day 09 – MariaDB Troubleshooting

---

## Task Overview  
There is a critical issue going on with the `Nautilus` application in `Stratos DC`. The production support team identified that the application is unable to connect to the database. After digging into the issue, the team found that mariadb service is down on the database server. 

Look into the issue and fix the same. 

---

## Step-by-Step Implementation  

### Step 1: Connect to Database Server  
```bash
ssh peter@stdb01
```
#### Explanation:  
The `ssh` command is used to connect securely to the remote database server. We run this command to access the system where MariaDB is installed so we can troubleshoot the issue.

### Step 2: Check MariaDB Logs  
```bash
tail -f /var/log/mariadb/mariadb.log
```
#### Explanation:  
The `tail -f` command displays the last lines of the log file and continuously shows new logs in real time.
- `-f` flag means follow, so it keeps showing new entries as they are written.
  
The `/var/log/mariadb/mariadb.log` file contains MariaDB error and activity logs.

We run this command to identify the root cause of the service failure by analyzing logs.

### Step 3: Check Service Status  
```bash
sudo systemctl status mariadb
```
#### Explanation:  
The `systemctl status mariadb` command checks the current state of the MariaDB service. The output shows whether the service is running, stopped, or failed.

The `sudo` keyword is used because checking system services requires elevated privileges.

We run this command to confirm that the MariaDB service is down.

### Step 4: Try to Start Service  
```bash
sudo systemctl start mariadb
```
#### Explanation:  
The `systemctl start mariadb` command attempts to start the MariaDB service. If the service fails, it will provide error messages that help in troubleshooting.

We run this command to test whether the issue is temporary or due to a configuration problem.

### Step 5: Check Detailed Errors  
```bash
sudo journalctl -xeu mariadb.service
```
#### Explanation:  
The `journalctl` command is used to view system logs managed by systemd.

The `-xeu mariadb.service` options filter logs specifically for the MariaDB service and shows detailed error messages.

We run this command to get deeper insights into why the service failed.

### Step 6: Check Data Directory  
```bash
ls -lah /var/lib/mysql
```
#### Explanation:  
The `ls -lah` command lists files and directories with detailed information.

The `/var/lib/mysql` directory is the default data directory where MariaDB stores database files. If this directory does not exist or is misconfigured, MariaDB will fail to start.

We run this command to verify whether the required directory exists.

### Step 7: Create Missing Directory  
```bash
sudo mkdir -p /var/lib/mysql
```
#### Explanation:  
The `mkdir` command creates a directory in the file system.
- `-p` flag ensures directory is created if not exists.

The `/var/lib/mysql` directory is required for MariaDB to store data files.

We run this command to fix the missing data directory issue.

### Step 8: Fix Ownership  
```bash
sudo chown -R mysql:mysql /var/lib/mysql
```
#### Explanation:  
The `chown` command changes ownership of files and directories.
- `-R` flag means recursive, so it applies changes to all files inside the directory.

The `mysql:mysql` specifies that both user and group ownership should be assigned to mysql. MariaDB runs as the mysql user, so it must have proper ownership of its data directory.

We run this command to ensure MariaDB can access and manage its files.

### Step 9: Restart MariaDB  
```bash
sudo systemctl restart mariadb
```
#### Explanation:  
The `systemctl restart mariadb` command stops and then starts the MariaDB service. This ensures that all changes (like directory and permissions) are applied.

We run this command to reinitialize MariaDB with correct configuration.

### Step 10: Verify Service  
```bash
sudo systemctl status mariadb
```
#### Explanation:  
This command checks whether MariaDB is now running successfully. The expected output should show **active (running)**.

We run this command to confirm that the issue is resolved.

### Step 11: Enable Service (Optional)  
```bash
sudo systemctl enable mariadb
```
#### Explanation:  
The `systemctl enable mariadb` command ensures the service starts automatically on system boot.

We run this command to make the configuration persistent across reboots.

---

## Best Practices  
- Always check logs first  
- Verify service status before fixing  
- Maintain correct permissions  
- Use monitoring tools  

## Key Learnings  

- Logs are the most important debugging tool  
- Services depend on correct file structure  
- Permissions are critical for database services  
- Systematic troubleshooting is essential  

---

**Next Challenge**: [Day 10 →](Day-10.md)
