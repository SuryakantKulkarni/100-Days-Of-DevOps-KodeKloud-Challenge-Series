# Day 49 – Deploy Applications with Kubernetes Deployments

---

## Task Overview  
The Nautilus DevOps team is delving into Kubernetes for app management. One team member needs to create a deployment following these details:

Create a deployment named `nginx` to deploy the application `nginx` using the image `nginx:latest` (ensure to specify the tag)

> Note: The kubectl utility on jump_host is set up to interact with the Kubernetes cluster.

---

## Step-by-Step Implementation  

### Step 1: Create YAML File  
```bash
cat > /tmp/nginx-deployment.yml << 'EOF'
# YAML content
EOF
```
#### Explanation:
Creates a YAML file using `cat`. We define deployment configuration including replicas and container.

Copy-Paste content from YAML File: [Day-49 YAML File →](Configs/Day-49-k8s-Deploy-Applications-with-Kubernetes.yaml)

### Step 2: Apply YAML File
```bash
kubectl apply -f /tmp/nginx-deployment.yml
```
#### Explanation:
`kubectl apply -f` creates deployment in Kubernetes. We run this to deploy application.

### Step 3: Verify Deployment
```bash
kubectl get deployment nginx
```
#### Explanation:
Displays deployment status. We run this to confirm deployment is created.

### Step 4: Verify Pods
```bash
kubectl get pods -l app=nginx
```
#### Explanation:
Lists pods created by deployment. We use label selector to filter relevant pods.

### Step 5: Detailed Inspection
```bash
kubectl describe deployment nginx
```
#### Explanation:
Shows detailed deployment configuration. We run this to inspect deployment properties.

---

## Config / YAML
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:latest
```

---

## Key Learnings
- Deployments are core Kubernetes resource
- Provide self-healing and scaling
- Replace manual pod management
- Essential for production environments
- Foundation for advanced Kubernetes concepts

---

**Next Challenge:** [Day 50 →](Tasks/Day-50.md)
