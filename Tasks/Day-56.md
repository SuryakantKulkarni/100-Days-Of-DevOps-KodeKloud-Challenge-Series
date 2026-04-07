# Day 56 – Deploy NGINX Web Server on Kubernetes Cluster

---

## Task Overview  
 

---

## Step-by-Step Implementation  

### Step 1: Create Deployment YAML  
```bash
cat > /tmp/nginx-deployment.yml << 'EOF'
# YAML content
EOF
```
#### Explanation:
The `cat` command creates a YAML file. We define deployment configuration including replicas and container details.

Copy-Paste content from YAML File: [Day-56 YAML File →](Configs/Day-56-k8s-Deploy-Nginx-Web-Server-on-Kubernetes.yaml)

### Step 2: Create Service YAML
```bash
cat > /tmp/nginx-service.yml << 'EOF'
# YAML content
EOF
```
Copy-Paste content from YAML File: [Day-56 YAML File →](Configs/Day-56-k8s-Deploy-Nginx-Web-Server-on-Kubernetes.yaml)

#### Explanation:
Creates a YAML file for service. This service will expose the application externally.

### Step 3: Apply Configuration
```bash
kubectl apply -f /tmp/nginx-deployment.yml
kubectl apply -f /tmp/nginx-service.yml
```
#### Explanation:
`kubectl apply` creates resources from YAML files. We run this to deploy application and service.

### Step 4: Verify Deployment
```bash
kubectl get deployment nginx-deployment
```
#### Explanation:
Checks deployment status. We run this to confirm replicas are created.

### Step 5: Verify Pods
```bash
kubectl get pods -l app=nginx
```
#### Explanation:
Lists pods using label filter. We run this to ensure all 3 pods are running.

### Step 6: Verify Service
```bash
kubectl get svc nginx-service
```
#### Explanation:
Lists services. We run this to confirm NodePort service is created.

---

## Config / YAML

#### Deployment
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx-container
          image: nginx:latest
```
### Service
```bash
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30011
```

---

## Key Learnings
- Kubernetes enables scalable deployments
- Replica-based architecture ensures reliability
- Services expose applications externally
- Labels are critical for connectivity
- High availability is essential in production

---

**Next Challenge: ** [Day 57 →](Tasks/Day-57.md)
