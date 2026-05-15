# Day 58 – Deploy Grafana on Kubernetes Cluster

---

## Task Overview  
The Nautilus DevOps teams is planning to set up a Grafana tool to collect and analyze analytics from some applications. They are planning to deploy it on Kubernetes cluster. Below you can find more details.

- Create a deployment named `grafana-deployment-xfusion` using any grafana image for Grafana app. Set other parameters as per your choice.

- Create `NodePort` type service with nodePort `32000` to expose the app.

`You need not to make any configuration changes inside the Grafana app once deployed, just make sure you are able to access the Grafana login page.`

---

## Step-by-Step Implementation  

### Step 1: Create YAML File  
```bash
cat > /tmp/grafana.yml << 'EOF'
# YAML content
EOF
```
### Explanation:
The `cat` command with `>` creates a YAML file. We run this to define deployment and service configuration.

### Step 2: Apply YAML File
```bash
kubectl apply -f /tmp/grafana.yml
```
#### Explanation:
`kubectl apply -f` reads the YAML file and creates resources. We run this to deploy Grafana on the cluster.

### Step 3: Verify Deployment
```bash
kubectl get deployment grafana-deployment-xfusion
```
#### Explanation:
Lists deployment status. We run this to confirm deployment is created successfully.

### Step 4: Verify Pods
```bash
kubectl get pods -l app=grafana
```
#### Explanation:
- `-l` → filter pods using label

We run this to check if pods are running.

### Step 5: Verify Service
```bash
kubectl get svc grafana-service
```
#### Explanation:
Lists services. We run this to confirm the NodePort service is created.

### Step 6: Wait for Pod
```bash
kubectl get pods -l app=grafana -w
```
#### Explanation:
- `-w` → watch pod status

We run this to wait until pod reaches Running state.

### Step 7: Access Grafana
```bash
kubectl get nodes -o wide
```
Then open:
```bash
http://<node-ip>:32000
```
#### Explanation:
Gets node IP address. We use NodePort to access Grafana from browser.

---

## Config / YAML
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana-deployment-xfusion
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
        - name: grafana
          image: grafana/grafana:latest
          ports:
            - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: grafana-service
spec:
  type: NodePort
  selector:
    app: grafana
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 32000
```

---

## Key Learnings
- Grafana is widely used for monitoring
- Kubernetes simplifies app deployment
- NodePort enables external access
- Labels are critical for connectivity
- Monitoring tools are essential in DevOps
