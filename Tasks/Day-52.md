# Day 52 – Revert Deployment to Previous Version in Kubernetes

---

## Task Overview  
Earlier today, the Nautilus DevOps team deployed a new release for an application. However, a customer has reported a bug related to this recent release. Consequently, the team aims to revert to the previous version.

There exists a deployment named `nginx-deployment`; initiate a rollback to the previous revision. 

> Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster. 

---

## Step-by-Step Implementation  

### Step 1: Check Deployment Status  
```bash
kubectl get deployment nginx-deployment
```
#### Explanation:
Displays deployment status. We run this to confirm the current state of deployment.

### Step 2: Check Rollout History
```bash
kubectl rollout history deployment/nginx-deployment
```
#### Explanation:
Shows all deployment revisions. We run this to identify available versions for rollback.

### Step 3: Perform Rollback
```bash
kubectl rollout undo deployment/nginx-deployment
```
#### Explanation:
Reverts deployment to previous revision. We run this to restore last working version.

### Step 4: Monitor Rollback
```bash
kubectl rollout status deployment/nginx-deployment
```
#### Explanation:
Tracks rollback progress. We run this to ensure deployment completes successfully.

### Step 5: Verify Image Version
```bash
kubectl describe deployment nginx-deployment | grep -i image
```
#### Explanation:
Displays container image details. We run this to confirm correct version is restored.

### Step 6: Verify Pods
```bash
kubectl get pods
```
#### Explanation:
Lists running pods. We run this to ensure all pods are healthy.

---

## Key Learnings
- Rollback is critical for production stability
- Kubernetes makes reverting easy
- Deployment history helps debugging
- Always verify after rollback
- Version control is essential in DevOps
