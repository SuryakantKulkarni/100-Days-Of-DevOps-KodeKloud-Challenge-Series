# Day 48 – Deploy Pods in Kubernetes Cluster

---

## Task Overview  
The Nautilus DevOps team is diving into Kubernetes for application management. One team member has a task to create a pod according to the details below:

- Create a pod named `pod-httpd` using the `httpd` image with the `latest` tag. Ensure to specify the tag as `httpd:latest`.

- Set the `app` label to `httpd_app`, and name the container as `httpd-container`.

> Note: The kubectl utility on jump_host is configured to operate with the Kubernetes cluster.

---

## Step-by-Step Implementation  

### Step 1: Create YAML File  
```bash
cat > /tmp/pod-httpd.yml << 'EOF'
# YAML content
EOF
```
#### Explanation:
Creates a YAML file using `cat`. We define pod configuration, container, and labels.

Copy-Paste content from YAML File: [Day-48 YAML File →](Configs/Day-48-k8s-Deploy-Pods-in-Kubernetes.yaml)

### Step 2: Apply YAML File
```bash
kubectl apply -f /tmp/pod-httpd.yml
```
#### Explanation:
`kubectl apply -f` creates the pod in Kubernetes. We run this to deploy the application.

### Step 3: Verify Pod
```bash
kubectl get pod pod-httpd
```
#### Explanation:
Checks pod status. We run this to confirm pod is running.

### Step 4: Verify Labels
```bash
kubectl get pod pod-httpd --show-labels
```
#### Explanation:
Displays labels assigned to pod. We run this to confirm correct labeling.

### Step 5: Detailed Info
```bash
kubectl describe pod pod-httpd
```
#### Explanation:
Shows full pod details including events and configuration.

---

## Config / YAML
```bash
apiVersion: v1
kind: Pod
metadata:
  name: pod-httpd
  labels:
    app: httpd_app
spec:
  containers:
    - name: httpd-container
      image: httpd:latest
```

---

## Key Learnings
- Pods are foundation of Kubernetes
- Labels are important for resource management
- Basic deployment starts with pods
- Understanding pods is essential before deployments

---

**Next Challenge:** [Day 49 →](Tasks/Day-49.md)
