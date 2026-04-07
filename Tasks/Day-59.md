# Day 59 – Troubleshoot Deployment Issues in Kubernetes

---

## Task Overview  
Last week, the Nautilus DevOps team deployed a redis app on Kubernetes cluster, which was working fine so far. This morning one of the team members was making some changes in this existing setup, but he made some mistakes and the app went down. We need to fix this as soon as possible. Please take a look.

The deployment name is `redis-deployment`. The pods are not in running state right now, so please look into the issue and fix the same.
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

---

## Step-by-Step Implementation  

### Step 1: Check Deployment Status  
```bash
kubectl get deployment redis-deployment
```
#### Explanation:
Lists deployment status. We run this to check if the deployment is available and healthy.

### Step 2: Check Pod Status
```bash
kubectl get pods -l app=redis
```
#### Explanation:
- `-l` → filter pods using label
We run this to see if pods are running or failing.

### Step 3: Inspect Pod Errors
```bash
kubectl describe pods -l app=redis
```
#### Explanation:
`kubectl describe` shows detailed pod information including events. We run this to identify the exact issue (image error, crash, config issue).

### Step 4: Inspect Deployment Configuration
```bash
kubectl describe deployment redis-deployment
```
#### Explanation:
Displays deployment configuration and status. We run this to check for misconfiguration.

### Step 5: View Full YAML
```bash
kubectl get deployment redis-deployment -o yaml
```
#### Explanation:
Outputs full deployment configuration. We run this to inspect all settings in detail.

### Step 6: Fix Common Issues

#### Fix 1: Incorrect Image
```bash
kubectl set image deployment/redis-deployment redis=redis:latest
```
#### Explanation:
Updates container image. Used when image name or tag is incorrect.

#### Fix 2: Wrong Port
```bash
kubectl edit deployment redis-deployment
```
Update:
```bash
containerPort: 6379
````
#### Explanation:
Redis uses port 6379. Fix incorrect port configuration.

#### Fix 3: Incorrect Command/Args
```bash
kubectl edit deployment redis-deployment
```
#### Explanation:
Remove invalid command or args causing container failure.

#### Fix 4: Volume Issues
```bash
kubectl edit deployment redis-deployment
```
#### Explanation:
Ensure volume and mount paths match correctly.

### Step 7: Verify Fix
```bash
kubectl get pods -l app=redis -w
kubectl get deployment redis-deployment
```
#### Explanation:
We run these commands to confirm that pods are running and deployment is healthy.

---

## Key Learnings
- Debugging is critical in Kubernetes
- Small misconfigurations can break deployments
- kubectl commands are powerful for troubleshooting
- Always verify changes after fixing
- Systematic approach saves time

---

**Next Challenge:** [Day 60 →](Tasks/Day-60.md)
