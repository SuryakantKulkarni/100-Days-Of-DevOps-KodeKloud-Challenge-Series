# Day 50 – Set Resource Limits in Kubernetes Pods

---

## Task Overview  
The Nautilus DevOps team has noticed performance issues in some Kubernetes-hosted applications due to resource constraints. To address this, they plan to set limits on resource utilization. Here are the details:

Create a pod named `httpd-pod` with a container named `httpd-container`. Use the `httpd` image with the `latest` tag (specify as `httpd:latest`). Set the following resource limits:

Requests: Memory: `15Mi`, CPU: `100m`

Limits: Memory: `20Mi`, CPU: `100m`

> Note: The kubectl utility on jump_host is configured to operate with the Kubernetes cluster.  

---

## Step-by-Step Implementation  

### Step 1: Create YAML File  
```bash
cat > /tmp/httpd-pod.yml << 'EOF'
# YAML content
EOF
```
#### Explanation:
Creates a YAML file using `cat`. We define pod configuration and resource limits.

### Step 2: Apply YAML File
```bash
kubectl apply -f /tmp/httpd-pod.yml
```
#### Explanation:
`kubectl apply -f` command creates the pod in the Kubernetes cluster. We run this to deploy the application.

### Step 3: Verify Pod Status
```bash
kubectl get pod httpd-pod
```
#### Explanation:
`kubectl get pod` command checks the status of the specific pod. We run this to confirm the pod is running.

### Step 4: Verify Resource Limits
```bash
kubectl describe pod httpd-pod | grep -A6 "Limits\|Requests"
```
#### Explanation:
`kubectl describe pod` command displays the resource configuration. We run this to confirm limits and requests are applied.

---

## Config / YAML
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: httpd-pod
spec:
  containers:
    - name: httpd-container
      image: httpd:latest
      resources:
        requests:
          memory: "15Mi"
          cpu: "100m"
        limits:
          memory: "20Mi"
          cpu: "100m"
```

---

## Key Learnings
- Resource limits are critical for stability
- Kubernetes enforces resource boundaries
- Prevents system-wide failures
- Improves performance and reliability
- Essential concept in production DevOps
