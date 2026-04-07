# Day 61 – Init Containers in Kubernetes

---

## Task Overview  
There are some applications that need to be deployed on Kubernetes cluster and these apps have some pre-requisites where some configurations need to be changed before deploying the app container. Some of these changes cannot be made inside the images so the DevOps team has come up with a solution to use init containers to perform these tasks during deployment. Below is a sample scenario that the team is going to test first.

- Create a Deployment named as `ic-deploy-devops`.

- Configure `spec` as replicas should be `1`, labels `app` should be `ic-nautilus`, template's metadata lables `app` should be the same `ic-nautilus`.

- The `initContainers` should be named as `ic-msg-nautilus`, use image `ubuntu` with `latest` tag and use command `'/bin/bash', '-c' and 'echo Init Done - Welcome to xFusionCorp Industries > /ic/ecommerce'`. The volume mount should be named as `ic-volume-nautilus` and mount path should be `/ic`.

- Main container should be named as `ic-main-nautilus`, use image `ubuntu` with `latest` tag and use command `'/bin/bash', '-c' and 'while true; do cat /ic/media; sleep 5; done'`. The volume mount should be named as `ic-volume-nautilus` and mount path should be `/ic`.

- Volume to be named as `ic-volume-nautilus` and it should be an `emptyDir` type.

> Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

---

## Step-by-Step Implementation  

### Step 1: Create YAML File  
```bash
cat > /tmp/ic-deploy-nautilus.yml << 'EOF'
# YAML content
EOF
```
#### Explanation:
The `cat` command with `>` creates a YAML file. We run this to define deployment, init container, main container, and volume configuration.

Copy-Paste the content from this YAML file.

### Step 2: Apply YAML File
```bash
kubectl apply -f /tmp/ic-deploy-nautilus.yml
```
#### Explanation:
`kubectl apply -f` reads the YAML file and creates resources in the cluster. We run this to deploy the application.

### Step 3: Verify Deployment
```bash
kubectl get deployment ic-deploy-nautilus
```
#### Explanation:
Lists deployment status. We run this to confirm deployment is created successfully.

### Step 4: Verify Pods
```bash
kubectl get pods -l app=ic-nautilus -w
```
#### Explanation:
- `-l` → filter by label
- `-w` → watch in real-time
We run this to observe pod lifecycle and init container execution.

### Step 5: Check Logs
```bash
kubectl logs <pod-name> -c ic-main-nautilus
```
#### Explanation:
`kubectl logs` shows container output. We run this to verify that the main container is reading data written by init container.

---

## Config/YAML File
```bash
kubectl logs → View container output
Config / YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ic-deploy-nautilus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ic-nautilus
  template:
    metadata:
      labels:
        app: ic-nautilus
    spec:
      volumes:
        - name: ic-volume-nautilus
          emptyDir: {}
      initContainers:
        - name: ic-msg-nautilus
          image: ubuntu:latest
          command: ['/bin/bash', '-c', 'echo Init Done - Welcome to xFusionCorp Industries > /ic/ecommerce']
          volumeMounts:
            - name: ic-volume-nautilus
              mountPath: /ic
      containers:
        - name: ic-main-nautilus
          image: ubuntu:latest
          command: ['/bin/bash', '-c', 'while true; do cat /ic/ecommerce; sleep 5; done']
          volumeMounts:
            - name: ic-volume-nautilus
              mountPath: /ic
```
---

## Key Learnings
- Init containers prepare environment before app starts
- Useful for real-world deployment scenarios
- Volumes enable data sharing between containers
- Improves modular and clean application setup

Next Challenge: Day 62 →
