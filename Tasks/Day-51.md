# Day 51 – Execute Rolling Updates in Kubernetes

---

## Task Overview  
An application currently running on the Kubernetes cluster employs the nginx web server. The Nautilus application development team has introduced some recent changes that need deployment. They've crafted an image `nginx:1.17` with the latest updates.

Execute a rolling update for this application, integrating the `nginx:1.17` image. The deployment is named `nginx-deployment`.

Ensure all pods are operational post-update.

> Note: The kubectl utility on jump_host is set up to operate with the Kubernetes cluster 

---

## Step-by-Step Implementation  

### Step 1: Get Container Name  
```bash
kubectl get deployment
```
#### Explanation:
Displays deployment status and name of container We run this because kubectl set image requires the exact container name.

### Step 2: Apply Rolling Update
```bash
kubectl set image deployment/nginx-deployment <container-name>=nginx:1.17
```
#### Explanation:
Updates container image in deployment. Kubernetes automatically performs rolling update (zero downtime).

### Step 3: Monitor Rollout
```bash
kubectl rollout status deployment/nginx-deployment
```
#### Explanation:
Shows rollout progress in real time. We run this to ensure update completes successfully.

### Step 4: Verify Updated Image
```bash
kubectl describe deployment nginx-deployment | grep -i image
```
#### Explanation:
Displays current image used in deployment. We run this to confirm update is applied.

### Step 5: Verify Pods
```bash
kubectl get pods
```
#### Explanation:
Lists all pods. We run this to ensure all pods are running successfully.

---

## Key Learnings
- Rolling updates ensure zero downtime
- Kubernetes automates deployment updates
- Monitoring rollout is critical
- Version upgrades must be verified
- Essential concept for production deployments
