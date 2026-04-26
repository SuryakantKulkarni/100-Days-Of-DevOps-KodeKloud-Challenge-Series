# Day 13 – IPtables Installation and Configuration

---

## Task Overview  
We have one of our websites up and running on our `Nautilus` infrastructure in `Stratos DC`. Our security team has raised a concern that right now Apache’s port i.e `5002` is open for all since there is no firewall installed on these hosts. So we have decided to add some security layer for these hosts and after discussions and recommendations we have come up with the following requirements:

- Install `iptables` and all its dependencies on each app host.

- Block incoming port `5002` on all apps for everyone except for LBR host.

- Make sure the rules remain, even after system reboot.

---

## Step-by-Step Implementation  

### Step 1: Install iptables  

```bash
sudo yum install -y iptables iptables-services
```
#### Explanation:  
The `yum install` command installs packages from repositories.  
- `-y` flag automatically confirms installation prompts  
- `iptables` provides firewall functionality  
- `iptables-services` provides service management support  

We run this command to install firewall tools required for network filtering.

### Step 2: Allow Load Balancer Access  

```bash
sudo iptables -A INPUT -p tcp --dport 5002 -s 172.16.238.14 -j ACCEPT
```
#### Explanation:  
The `iptables` command modifies firewall rules.  
- `-A INPUT` appends rule to INPUT chain (incoming traffic)  
- `-p tcp` matches TCP protocol  
- `--dport 5002` matches destination port 5002  
- `-s 172.16.238.14` allows only this source IP (Load Balancer)  
- `-j ACCEPT` allows matching traffic  

We run this command to whitelist the Load Balancer.

### Step 3: Verify Rule  

```bash
sudo iptables -L INPUT -n -v --line-numbers
```
#### Explanation:  
The `iptables -L` command lists firewall rules.  
- `INPUT` shows incoming rules  
- `-n` flag shows numeric IP/ports (faster, no DNS lookup)  
- `-v` flag shows packet/byte counters  
- `--line-numbers` shows rule order  

We run this command to confirm the ACCEPT rule is added correctly.

### Step 4: Block All Other Traffic  

```bash
sudo iptables -A INPUT -p tcp --dport 5002 -j REJECT
```
#### Explanation:  
The `iptables` command adds another rule.  
- `-A INPUT` appends rule  
- `-p tcp` matches TCP traffic  
- `--dport 5002` targets port 5002
- `-j REJECT` denies connection and sends response  

We run this command to block all non-authorized traffic.

### Step 5: Verify Rule Order  

```bash
sudo iptables -L INPUT -n -v --line-numbers
```
#### Explanation:  
This command checks rule order in INPUT chain. We run this to ensure ACCEPT rule is above REJECT rule because iptables processes rules top to bottom.

### Step 6: Save Rules  

```bash
sudo service iptables save
```
#### Explanation:  
The `service` command manages system services.  
- `iptables save` writes current rules to disk  

We run this command to persist firewall rules after reboot.

### Step 7: Enable and Start iptables  

```bash
sudo systemctl enable iptables
sudo systemctl start iptables
```
#### Explanation:  
The `systemctl enable` command enables service at boot.  
The `systemctl start` command starts service immediately.  

We run these commands to ensure firewall is always active.

### Step 8: Test from Load Balancer  

```bash
curl http://app-server:5002
```
#### Explanation:  
The `curl` command sends an HTTP request.  
- `app-server:5002` is target server and port  

We run this command from Load Balancer to verify access is allowed.

### Step 9: Test from Other Hosts  

```bash
curl http://app-server:5002
```
#### Explanation:  
This command tests access from unauthorized systems. We run this to confirm firewall blocks traffic correctly.

### Step 10: View Saved Rules  

```bash
sudo cat /etc/sysconfig/iptables
```
#### Explanation:  
The `cat` command displays file contents.  
- `/etc/sysconfig/iptables` stores saved firewall rules  

We run this to verify rules are persisted.

### Step 11: Check Service Status  

```bash
sudo systemctl status iptables
```
#### Explanation:  
The `systemctl status` command shows service state. We run this to confirm iptables service is active and enabled.

### Step 12: View All Rules  

```bash
sudo iptables -L -n -v
```
#### Explanation:  
The `iptables -L` lists all chains and rules.  
- `-n` flag gives numeric output  
- `-v` flag gives detailed statistics  

We run this to get complete firewall overview.

### Step 13: Monitor Traffic Live  

```bash
watch -n 1 'sudo iptables -L INPUT -n -v --line-numbers'
```
#### Explanation:  
The `watch` command runs a command repeatedly.  
- `-n 1` refreshes every 1 second  

We run this to monitor real-time packet flow and rule usage.

---

## Key Learnings  
- iptables works on rule order (top to bottom)  
- First match rule is applied  
- ACCEPT allows traffic, REJECT denies with response  
- Saving rules ensures persistence  
- Monitoring helps debug traffic  
