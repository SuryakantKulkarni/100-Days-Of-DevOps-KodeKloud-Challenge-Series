# Day 65 – Deploy Redis Deployment on Kubernetes

---

## Task Overview  
The Nautilus application development team observed some performance issues with one of the application that is deployed in Kubernetes cluster. After looking into number of factors, the team has suggested to use some in-memory caching utility for DB service. After number of discussions, they have decided to use Redis. Initially they would like to deploy Redis on kubernetes cluster for testing and later they will move it to production. Please find below more details about the task:

- Create a redis deployment with following parameters:

- Create a `config map` called `my-redis-config` having maxmemory `2mb` in `redis-config`.

- Name of the `deployment` should be `redis-deployment`, it should use `redis:alpine` image and container name should be `redis-container`. Also make sure it has only `1` replica.

- The container should request for `1 CPU`.

- Mount 2 volumes:

  - An Empty directory volume called `data` at path `/redis-master-data`.

  - A configmap volume called `redis-config` at path `/redis-master`.

  - The container should expose the port `6379`.

- Finally, `redis-deployment` should be in an up and running state.

> Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

---

## Step-by-Step Implementation  

### Step 1: Create Full Manifest  
```bash
cat > /tmp/redis-deployment.yml << 'EOF'
# YAML content
EOF
```
#### Explanation:
This command creates a YAML file using `cat`. In this file, we define both the **ConfigMap** and the **Deployment**. Keeping everything in one file makes it easier to manage and deploy all resources together.

Copy-Paste content from YAML File: [Day-65 YAML File →](Configs/Day-65-k8s-Redis-Deployment-on-Kubernetes.yaml)

### Step 2: Apply the Manifest
```bash
kubectl apply -f /tmp/redis-deployment.yml
```
#### Explanation:
The `kubectl apply -f` command reads the YAML file and creates all defined resources in the Kubernetes cluster. It ensures that the cluster state matches the configuration in the file. We use this to deploy Redis and its configuration.

### Step 3: Verify ConfigMap
```bash
kubectl get configmap my-redis-config
kubectl describe configmap my-redis-config
```
#### Explanation:
These commands check whether the ConfigMap is created successfully.

* `kubectl get configmap` command lists the ConfigMap
* `kubectl describe configmap` command shows detailed information like stored key-value data

### Step 4: Verify Deployment
```bash
kubectl get deployment redis-deployment
```
#### Explanation:
The `kubectl get deployment` command checks if the deployment has been created successfully. It also shows whether the desired number of pods are running and ready.

### Step 5: Verify Pods
```bash 
kubectl get pods -l app=redis -w
```
#### Explanation:
The `kubectl get pods -l` command lists the pods created by the deployment.

- `-l` flag stands for label selector, and it requires you to provide a key-value pair to narrow down your result.
- `-w` (watch) flag continuously monitors the pod status in real time until they reach the **Running** state.

---

## Config / YAML
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-redis-config
data:
  redis-config: |
    maxmemory 2mb
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
        - name: redis-container
          image: redis:alpine
          ports:
            - containerPort: 6379
          resources:
            requests:
              cpu: "1"
          volumeMounts:
            - name: data
              mountPath: /redis-master-data
            - name: redis-config
              mountPath: /redis-master
      volumes:
        - name: data
          emptyDir: {}
        - name: redis-config
          configMap:
            name: my-redis-config
```

---

## Key Learnings
- ConfigMaps decouple config from application
- Redis improves performance drastically
- Volumes enable data + config sharing
- Kubernetes deployments are flexible and scalable
- Resource requests ensure stability

---

Next Challenge: [Day 66 →]()
