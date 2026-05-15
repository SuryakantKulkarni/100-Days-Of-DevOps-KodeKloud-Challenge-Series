# Day 06 – Create a Cron Job

---

## Task Overview  
The `Nautilus` system admins team has prepared scripts to automate several day-to-day tasks. They want them to be deployed on all app servers in `Stratos DC` on a set schedule. Before that they need to test similar functionality with a sample cron job. Therefore, perform the steps below:

- Install `cronie` package on all `Nautilus` app servers and start `crond` service.
- Add a cron `*/5 * * * * echo hello > /tmp/cron_text` for `root` user.
  
---

## Step-by-Step Implementation  

### Step 1: Connect to Server  
```bash
ssh tony@stapp01.stratos.xfusioncorp.com
```
#### Explanation:
The `ssh` command is used to connect to the remote server. We run this to access the App Server. 

### Step 2: Install Cron Service
```bash
sudo yum install cronie -y
```
#### Explanation:
The `yum` install` command installs the cron service package on the system. Cronie provides the crond daemon and crontab utilities required to schedule and run automated tasks.
- `-y` flag automatically confirms the installation without asking for user input, making the process faster and suitable for automation.

We run this command to ensure the system has the required service to schedule background jobs.

### Step 3: Enable Cron Service
```bash
sudo systemctl enable crond
```
#### Explanation:
The `systemctl enable` command configures the cron service to start automatically whenever the system boots.
- `enable` option creates symbolic links in systemd so that the service is loaded during startup.

We run this command to make sure scheduled jobs continue working even after system reboot.

### Step 4: Start Cron Service
```bash
sudo systemctl start crond
```
#### Explanation:
The `systemctl start` command starts the cron daemon immediately without waiting for a reboot. This command launches the background process responsible for reading crontab files and executing scheduled tasks.

We run this command to activate the cron service so jobs can start executing.

### Step 5: Verify Cron Service
```bash
sudo systemctl status crond
```
#### Explanation:
The `systemctl status crond` command checks the current status of the cron service. It displays whether the service is running, stopped, or failed. The expected output should show active (running).

We run this command to ensure the cron service is working properly before adding jobs.

### Step 6: Open Crontab File
```bash
sudo crontab -e
```
#### Explanation:
The `crontab -e` command opens the cron configuration file for the root user in an editor.
- `-e` flag stands for edit and allows you to add or modify scheduled jobs.

We run this command to define scheduled jobs.

### Step 7: Add Cron Job
```bash
*/5 * * * * echo hello > /tmp/cron_text
```
#### Explanation:
This line defines a cron job that runs a command at a fixed interval.
- `*/5` in the minute field means the job runs every 5 minutes.
- `*` in other fields means every hour, day, month, and weekday.
- `echo hello` command prints the word "hello".
- `>` operator redirects the output to the file /tmp/cron_text, overwriting its content each time.

We add this job to test whether cron scheduling is working correctly.

### Step 8: Verify Cron Job
```bash
sudo crontab -l
```
#### Explanation:
The `crontab -l` command lists all cron jobs configured for the current user (root in this case).
- `-l` flag stands for list and displays the contents of the crontab file.

We run this command to confirm that the cron job was added successfully.

### Step 9: Verify Cron Execution
```bash
cat /tmp/cron_text
```
#### Explanation:
The `cat` command reads the contents of the file where cron job output is stored. After waiting for at least 5 minutes, this file should contain the word hello.

We run this command to verify that the cron job executed successfully.

---

## Key Concepts

### Cron Time Format:

The cron schedule consists of 5 time fields followed by the command:
```
* * * * * command
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, where both 0 and 7 = Sunday)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

### Special Characters:

- `*` (asterisk): Matches all values (every minute, hour, day, etc.)
- `,` (comma): Lists multiple values (1,15,30 = 1st, 15th, and 30th)
- `-` (hyphen): Specifies ranges (1-5 = 1,2,3,4,5)
- `/` (slash): Specifies step values (*/5 = every 5 units)

### Common Cron Schedule Examples:

```sh
# Every 5 minutes
*/5 * * * * command

# Every hour at minute 0
0 * * * * command

# Every day at 2:30 AM
30 2 * * * command

# Every Monday at 9:00 AM
0 9 * * 1 command

# First day of every month at midnight
0 0 1 * * command

# Every 15 minutes during business hours (9 AM - 5 PM)
*/15 9-17 * * * command

# Twice a day (6 AM and 6 PM)
0 6,18 * * * command
```

---

**Automation Script (Optional):**

For deploying across multiple servers, you can use this automation script:

```bash
#!/bin/sh
# setup_cron_job.sh - Automate cron job deployment

set -e  # Exit on any error

echo "=== Setting up Cron Job on CentOS ==="

# Install cronie package
echo "Installing cronie package..."
if ! rpm -q cronie &>/dev/null; then
    sudo yum install cronie -y
    echo "✓ cronie package installed"
else
    echo "✓ cronie package already installed"
fi

# Start and enable crond service
sudo systemctl start crond
sudo systemctl enable crond
echo "✓ crond service configured"

# Add cron job for root user
CRON_JOB="*/5 * * * * echo hello > /tmp/cron_text"
if sudo crontab -l 2>/dev/null | grep -q "echo hello > /tmp/cron_text"; then
    echo "✓ Cron job already exists"
else
    (sudo crontab -l 2>/dev/null || true; echo "$CRON_JOB") | sudo crontab -
    echo "✓ Cron job added successfully"
fi

echo "=== Setup Complete ==="
```

---

## Key Learnings  
- Cron automates repetitive tasks  
- Service must be active for jobs to run  
- Proper syntax is critical  
- Widely used in production systems  
