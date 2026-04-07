# Day 60 – Persistent Volumes in Kubernetes

---

## Task Overview  
The Nautilus DevOps team is working on a Kubernetes template to deploy a web application on the cluster. There are some requirements to create/use persistent volumes to store the application code, and the template needs to be designed accordingly. Please find more details below:

- Create a `PersistentVolume` named as `pv-nautilus`. Configure the `spec` as storage class should be `manual`, set capacity to `3Gi`, set access mode to `ReadWriteOnce`, volume type should be `hostPath` and set path to `/mnt/sysops` (this directory is already created, you might not be able to access it directly, so you need not to worry about it).
- Create a `PersistentVolumeClaim` named as `pvc-nautilus`. Configure the `spec` as storage class should be `manual`, request `3Gi` of the storage, set access mode to `ReadWriteOnce`.
- Create a `pod` named as `pod-nautilus`, mount the persistent volume you created with claim name `pvc-nautilus` at document root of the web server, the container within the pod should be named as `container-nautilus` using image `nginx` with `latest` tag only (remember to mention the tag i.e `nginx:latest`).
- Create a node port type service named `web-nautilus` using node port `30008` to expose the web server running within the pod.

> Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

---

## Step-by-Step Implementation  

### Step 1: Create YAML File  
```bash
cat > /tmp/nautilus-pv.yml << 'EOF'
# YAML filecontent
EOF
```
#### Explanation
The `cat` command with `>` creates a YAML file. We run this to define PV, PVC, Pod, and Service configuration in one place.

Copy-Paste content from YAML File: [Day-60 YAML File →](Configs/Day-60-k8s-Persistent-Volumes-in-Kubernetes.yaml)

### Step 2: Apply YAML File
```bash
kubectl apply -f /tmp/nautilus-pv.yml
```
#### Explanation:
`kubectl apply -f` reads the YAML file and creates resources in the cluster. We run this to deploy storage and application components.

### Step 3: Verify Persistent Volume
```bash
kubectl get pv pv-nautilus
```
#### Explanation:
Lists persistent volumes. We run this to confirm PV is created and in Bound state.

### Step 4: Verify Persistent Volume Claim
```bash
kubectl get pvc pvc-nautilus
```
#### Explanation:
Lists PVCs. We run this to ensure PVC is successfully bound to PV.

### Step 5: Verify Pod
```bash
kubectl get pod pod-nautilus -w
```
#### Explanation:
- `-w` → watch pod status
We run this to ensure pod reaches Running state.

### Step 6: Verify Service Endpoints
```bash
kubectl get endpoints web-nautilus
```
#### Explanation:
Shows service endpoints. We run this to confirm the service is correctly connected to the pod.

---

## Config / YAML
```bash
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nautilus
spec:
  storageClassName: manual
  capacity:
    storage: 3Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/sysops
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nautilus
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: pod-nautilus
  labels:
    app: web-nautilus
spec:
  volumes:
    - name: pv-nautilus
      persistentVolumeClaim:
        claimName: pvc-nautilus
  containers:
    - name: container-nautilus
      image: nginx:latest
      ports:
        - containerPort: 80
      volumeMounts:
        - name: pv-nautilus
          mountPath: /usr/share/nginx/html
---
apiVersion: v1
kind: Service
metadata:
  name: web-nautilus
spec:
  type: NodePort
  selector:
    app: web-nautilus
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30008
```

---

## Key Learnings
- Kubernetes separates storage from compute
- PV and PVC enable persistent data
- Proper binding is critical
- Services require correct labels
- Storage is essential for real-world apps

---

**Next Challenge:** [Day 61 →](Tasks/Day-62.md)
