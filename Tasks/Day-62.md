# Day 62 - Manage Secrets in Kubernetes

---

## Task Overview
The Nautilus DevOps team is working to deploy some tools in Kubernetes cluster. Some of the tools are licence based so that licence information needs to be stored securely within Kubernetes cluster. Therefore, the team wants to utilize Kubernetes secrets to store those secrets. Below you can find more details about the requirements:
- We already have a secret key file `ecommerce.txt` under the `/opt/` directory. Create a generic secret named `ecommerce`, it should contain the password/license-number present in `ecommerce.txt` file.
- Also create a pod named `secret-xfusion`.
- Configure pod's spec as container name should be `secret-container-xfusion`, image should be `fedora` with latest tag (remember to mention the tag with image). Use sleep command for container so that it remains in running state. Consume the created secret and mount it under `/opt/demo` within the container.
- To verify you can exec into the container `secret-container-xfusion`, to check the secret key under the mounted path `/opt/demo`. Before hitting the Check button please make sure pod/pods are in running state, also validation can take some time to complete so keep patience.
> Note: The kubectl utility on the jump-host has been configured to work with the Kubernetes cluster.

---

## Step-by-Step Implementation  

## Step 1: Verify Secret File  
```bash
cat /opt/ecommerce.txt
```
#### Explanation:
The `cat` command is used to read file content. We run this to check the data that will be stored inside the Kubernetes secret.

## Step 2: Create Secret
```bash
kubectl create secret generic ecommerce --from-file=/opt/ecommerce.txt
```
#### Explanation:
`kubectl create secret` used to create a secret.
- `generic` → allows storing custom data
- `--from-file` → reads data from file
We run this to securely store sensitive data in Kubernetes.

## Step 3: Verify Secret
```bash
kubectl get secret ecommerce
kubectl describe secret ecommerce
```
#### Explanation:
`kubectl get secret` lists secrets
`kubectl describe secret` shows detailed information
We run this to confirm the secret was created successfully.

## Step 4: Create YAML File for Pod
```bash
cat > /tmp/secret-xfusion.yml << 'EOF'
YAML File Content
EOF
```
#### Explanation:
The cat command with > creates a YAML file. This file defines Pod configuration, Secret volume and Container setup. We run this to configure how the secret will be used inside the pod.

## Step 5: Apply YAML File
```bash
kubectl apply -f /tmp/secret-xfusion.yml
```
#### Explanation:
`kubectl apply -f` reads the YAML file and creates the pod. We run this to deploy the pod with the mounted secret.

## Step 6: Verify Pod Status
```bash
kubectl get pod secret-xfusion -w
```
#### Explanation:
`kubectl get pod -w` watches pod status in real time. We run this to ensure the pod reaches Running state.

## Step 7: Verify Secret Inside Container
```bash
kubectl exec secret-xfusion -c secret-container-xfusion -- ls /opt/demo/
kubectl exec secret-xfusion -c secret-container-xfusion -- cat /opt/demo/ecommerce.txt
```
#### Explanation:
`kubectl exec` runs commands inside the container
`ls` checks files
`cat` reads file content
We run this to confirm the secret is mounted and accessible.

---

## Key Learnings
- Kubernetes secrets securely manage sensitive data
- Secrets are base64 encoded (not encrypted by default)
- Mounted secrets are automatically decoded inside containers
- Secrets can be accessed as files or environment variables
- Proper secret management is critical for production systems

---

**Next Challenge:** [Day 63 →](Tasks/Day-63.md)
