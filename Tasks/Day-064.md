# Day 64 – Fix Python App Deployment on Kubernetes Cluster

---

## Task Overview  
One of the DevOps engineers was trying to deploy a python app on Kubernetes cluster. Unfortunately, due to some mis-configuration, the application is not coming up. Please take a look into it and fix the issues. Application should be accessible on the specified nodePort.

- The deployment name is `python-deployment-devops`, it is using `poroko/flask-demo-app` image. The deployment and service of this app is already deployed.

- nodePort should be `32345` and targetPort should be python flask app's default port.

> Note: The kubectl on jump_host has been configured to work with the kubernetes cluster. 

---

## Step-by-Step Implementation  

### Step 1: Check Pod Status  
```bash
kubectl get pods
```
#### Explanation:  
The `kubectl get pods` command lists all pods in the cluster.

We run this command to check if the application pods are running or failing.

### Step 2: Describe Pod for Errors  
```bash
kubectl describe pod <pod-name>
```
#### Explanation:  
The `kubectl describe pod` command shows detailed information including events and errors.

We run this command to identify the root cause of failure.

### Step 3: Identify Issue (ImagePullBackOff)

#### Observation:
- Error: `ErrImagePull` / `ImagePullBackOff`  
- Wrong image: `poroko/flask-app-demo`

#### Explanation:  
The error indicates Kubernetes is unable to pull the Docker image. This happens because the image name is incorrect or does not exist.

### Step 4: Export Deployment YAML  
```bash
kubectl get deployment python-deployment-devops -o yaml > k3s-deployment.yaml
```
#### Explanation:  
The `kubectl get -o yaml` command exports the current deployment configuration.

We run this command to edit and fix the deployment.

### Step 5: Fix Docker Image  
```bash
vi k3s-deployment.yaml
```

#### Change:
```yaml
image: poroko/flask-demo-app
```

#### Explanation:  
The `vi` command opens the YAML file for editing. 

We replace the incorrect image with the correct one. This ensures Kubernetes can pull the valid application image.

### Step 6: Recreate Deployment  
```bash
kubectl delete deployment python-deployment-devops
kubectl apply -f k3s-deployment.yaml
```
#### Explanation:  
The `kubectl delete` command removes the faulty deployment.

The `kubectl apply` command recreates it with corrected configuration.

We run these commands to deploy the fixed version.

### Step 7: Verify Pods  
```bash
kubectl get pods
```
#### Explanation:  
We run this command to ensure pods are now in `Running` state.

### Step 8: Check Service  
```bash
kubectl get svc
```
#### Explanation:  
The `kubectl get svc` command lists services and their ports.

We run this command to verify NodePort configuration.

### Step 9: Identify Service Issue  

#### Observation:
```
8080:32345/TCP
```
#### Problem:
- targetPort is incorrect  
- Flask default port should be **5000**

### Step 10: Export Service YAML  
```bash
kubectl get svc python-service-devops -o yaml > k3s-service.yaml
```
#### Explanation:  
This command exports service configuration. We run this command to fix incorrect port mapping.

### Step 11: Fix targetPort  
```bash
vi k3s-service.yaml
```
#### Change:
```yaml
targetPort: 5000
nodePort: 32345
```
#### Explanation:  
The `targetPort` must match the container’s listening port. Flask apps run on port `5000` by default.

We fix this so traffic routes correctly.

### Step 12: Apply Service Fix  
```bash
kubectl apply -f k3s-service.yaml
```
#### Explanation:  
This command updates the service with corrected configuration.

### Step 13: Verify Service  
```bash
kubectl get svc
```
#### Explanation:  
We run this command to confirm correct NodePort and targetPort.

### Step 14: Access Application  
```bash
curl http://<node-ip>:32345
```
#### Explanation:  
The `curl` command sends HTTP request to application.

We run this command to verify the app is accessible.

---

## Best Practices  
- Always verify image name before deployment  
- Match container port with service targetPort  
- Use `kubectl describe` for debugging  
- Test service after deployment  

## Key Learnings  

- Debugging Kubernetes requires checking pods and events  
- Image issues are common deployment failures  
- Service configuration is critical for accessibility  
- YAML editing is core DevOps skill  
