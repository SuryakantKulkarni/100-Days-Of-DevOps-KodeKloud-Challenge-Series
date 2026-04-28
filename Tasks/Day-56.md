# Day 56 – Deploy NGINX Web Server on Kubernetes Cluster

---

## Task Overview  
Some of the Nautilus team developers are developing a static website and they want to deploy it on Kubernetes cluster. They want it to be highly available and scalable. Therefore, based on the requirements, the DevOps team has decided to create a deployment for it with multiple replicas. Below you can find more details about it:

- Create a deployment using `nginx` image with `latest` tag only and remember to mention the tag i.e `nginx:latest`. Name it as `nginx-deployment`. The container should be named as `nginx-container`, also make sure replica counts are `3`.

- Create a `NodePort` type service named `nginx-service`. The nodePort should be `30011`.

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

### Step 2: Create Service YAML
```bash
cat > /tmp/nginx-service.yml << 'EOF'
# YAML content
EOF
```
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
```yaml
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
```yaml
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
