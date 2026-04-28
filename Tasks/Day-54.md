# Day 54 – Kubernetes Shared Volumes

---

## Task Overview  
We are working on an application that will be deployed on multiple containers within a pod on Kubernetes cluster. There is a requirement to share a volume among the containers to save some temporary data. The Nautilus DevOps team is developing a similar template to replicate the scenario. Below you can find more details about it.

- Create a pod named `volume-share-nautilus`.

- For the first container, use image `fedora` with `latest` tag only and remember to mention the tag i.e `fedora:latest`, container should be named as `volume-container-nautilus-1`, and run a `sleep` command for it so that it remains in running state. Volume `volume-share` should be mounted at path `/tmp/media`.

- For the second container, use image `fedora` with `latest` tag only and remember to mention the tag i.e `fedora:latest`, container should be named as `volume-container-nautilus-2`, and again run a `sleep` command for it so that it remains in running state. Volume `volume-share` should be mounted at path `/tmp/games`.

- Volume name should be `volume-share` of type `emptyDir`.

- After creating the pod, exec into the first container i.e `volume-container-nautilus-1`, and just for testing create a file `media.txt` with the content `Welcome to xFusionCorp Industries` under the mounted path of first container i.e `/tmp/media`.

- The file `media.txt` should be present under the mounted path `/tmp/games` on the second container `volume-container-nautilus-2` as well, since they are using a shared volume.

> Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster. 

---

## Step-by-Step Implementation  

### Step 1: Create YAML File  
```bash
cat > /tmp/volume-share-xfusion.yml << 'EOF'
# YAML content
EOF
```
#### Explanation:
The `cat` command creates a YAML file. We define pod, containers, and shared volume configuration.

### Step 2: Apply YAML File
```bash
kubectl apply -f /tmp/volume-share-xfusion.yml
```
#### Explanation:
`kubectl apply -f` creates the pod in Kubernetes. We run this to deploy both containers.

### Step 3: Verify Pod Status
```bash
kubectl get pod volume-share-xfusion -w
```
#### Explanation:
- `-w` → watch pod status
We run this to ensure both containers reach Running (2/2) state.

### Step 4: Create File in First Container
```bash
kubectl exec volume-share-xfusion -c volume-container-xfusion-1 -- \
sh -c "echo 'Welcome to xFusionCorp Industries' > /tmp/media/media.txt"
```
#### Explanation:
`kubectl exec` runs commands inside container. We create a file in the shared volume.

### Step 5: Verify in First Container
```bash
kubectl exec volume-share-xfusion -c volume-container-xfusion-1 -- \
cat /tmp/media/media.txt
```
#### Explanation:
Reads file from first container. We run this to confirm file creation.

### Step 6: Verify in Second Container
```bash
kubectl exec volume-share-xfusion -c volume-container-xfusion-2 -- \
cat /tmp/games/media.txt
```
Explanation:
Reads file from second container. We run this to confirm shared volume is working.

---

## Config / YAML
```bash
apiVersion: v1
kind: Pod
metadata:
  name: volume-share-xfusion
spec:
  volumes:
    - name: volume-share
      emptyDir: {}
  containers:
    - name: volume-container-xfusion-1
      image: fedora:latest
      command: ["sleep", "10000"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/media
    - name: volume-container-xfusion-2
      image: fedora:latest
      command: ["sleep", "10000"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/games
```

---

## Key Learnings
- Containers in same pod can share storage
- emptyDir enables temporary data sharing
- Multi-container pods improve flexibility
- Data consistency is maintained across containers
- Important concept for real-world DevOps setups
