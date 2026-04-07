# Day 53 – Resolve VolumeMounts Issue in Kubernetes

---

## Task Overview  
We encountered an issue with our Nginx and PHP-FPM setup on the Kubernetes cluster this morning, which halted its functionality. Investigate and rectify the issue:

The pod name is `nginx-phpfpm` and configmap name is `nginx-config`. Identify and fix the problem.

Once resolved, copy `/home/thor/index.php` file from the `jump host` to the `nginx-container` within the nginx document root. After this, you should be able to access the website using `Website` button on the top bar.

Note: The kubectl utility on jump_host is configured to operate with the Kubernetes cluster.

---

## Step-by-Step Implementation  

### Step 1: Export Pod YAML  
```bash
kubectl get pod nginx-phpfpm -o yaml > /tmp/nginx-phpfpm.yml
```
#### Explanation:
Exports pod configuration into a YAML file. We run this to inspect and fix configuration.

### Step 2: Fix Volume Mount Path
```bash
sed -i 's|/usr/share/nginx/html|/var/www/html|g' /tmp/nginx-phpfpm.yml
```
#### Explanation:
The `sed` command modifies file content. We replace incorrect mount path with correct path used by PHP-FPM.

### Step 3: Verify Changes
```bash
grep "mountPath" /tmp/nginx-phpfpm.yml
```
#### Explanation:
Checks updated mount paths. We run this to confirm correct configuration.

### Step 4: Recreate Pod
```bash
kubectl delete pod nginx-phpfpm
kubectl apply -f /tmp/nginx-phpfpm.yml
```
#### Explanation:
Deletes old pod and recreates it with updated config. We run this to apply fixes.

### Step 5: Wait for Pod
```bash
kubectl get pod nginx-phpfpm -w
```
#### Explanation:
- `-w` → watch pod status

We run this to ensure pod reaches 2/2 Running.

### Step 6: Copy File into Container
```bash
kubectl cp /home/thor/index.php nginx-phpfpm:/var/www/html/index.php -c nginx-container
```
#### Explanation:
Copies file from local system into container. We run this to place application file in web root.

### Step 7: Verify Setup
```bash
kubectl exec nginx-phpfpm -c nginx-container -- ls /var/www/html/
kubectl get pod nginx-phpfpm
```
#### Explanation:
`kubectl exec` → run command inside container

We verify file presence and pod status.

---

## Key Learnings
- Small configuration errors can break applications
- Volume mounts are critical in multi-container setups
- Debugging is a key DevOps skill
- Always verify after applying fixes
- Systematic approach saves time

---

**Next Challenge:** [Day 54 →](Tasks/Day-54.md)
