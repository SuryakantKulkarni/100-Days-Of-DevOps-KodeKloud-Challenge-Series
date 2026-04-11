# Day 67 – Deploy Guestbook App on Kubernetes

---

## Task Overview  
The Nautilus Application development team has finished development of one of the applications and it is ready for deployment. It is a guestbook application that will be used to manage entries for guests/visitors. As per discussion with the DevOps team, they have finalized the infrastructure that will be deployed on Kubernetes cluster. Below you can find more details about it.

**`BACK-END TIER`**

- Create a deployment named `redis-master` for Redis master.
  
  - Replicas count should be `1`.

  - Container name should be `master-redis-nautilus` and it should use image `redis`.

  - Request resources as `CPU` should be `100m` and `Memory` should be `100Mi`.

  - Container port should be redis default port i.e `6379`.

- Create a service named `redis-master` for Redis master. Port and targetPort should be Redis default port i.e `6379`.

- Create another deployment named `redis-slave` for Redis slave.

  - Replicas count should be `2`.

  - Container name should be `slave-redis-nautilus` and it should use `gcr.io/google_samples/gb-redisslave:v3` image.

  - Requests resources as `CPU` should be `100m` and `Memory` should be `100Mi`.

  - Define an environment variable named `GET_HOSTS_FROM` and its value should be `dns`.

  - Container port should be Redis default port i.e `6379`.

- Create another service named `redis-slave`. It should use Redis default port i.e `6379`.

**`FRONT END TIER`**

- Create a deployment named `frontend`.

  -  Replicas count should be `3`.

  - Container name should be `php-redis-nautilus` and it should use `gcr.io/google-samples/gb-frontend@sha256:a908df8486ff66f2c4daa0d3d8a2fa09846a1fc8efd65649c0109695c7c5cbff` image.

  - Request resources as `CPU` should be `100m` and `Memory` should be `100Mi`.

  - Define an environment variable named as `GET_HOSTS_FROM` and its value should be `dns`.

  - Container port should be `80`.

- Create a service named `frontend`. Its `type` should be `NodePort`, port should be `80` and its `nodePort` should be `30009`.

Finally, you can check the guestbook app by clicking on App button.

You can use any labels as per your choice.

> Note: The kubectl utility on the jump-host has been configured to work with the Kubernetes cluster. 

---

## Step-by-Step Implementation  

### Step 1: Create Redis Master Manifest  
```bash
cat > /tmp/redis-master.yml << 'EOF'
# YAML content
EOF
```
#### Explanation:  
The `cat > file << 'EOF'` command is used to create a YAML manifest file. This file defines both a Deployment and a Service for Redis Master.

We use this step to prepare backend configuration before deployment.

### Step 2: Apply Redis Master  
```bash
kubectl apply -f /tmp/redis-master.yml
```
#### Explanation:  
The `kubectl apply -f` command applies the YAML configuration to the Kubernetes cluster. This creates the Redis Master deployment and service.

We run this command to start the backend database layer.

### Step 3: Verify Redis Master  
```bash
kubectl get pods -l role=master
kubectl get svc redis-master
```
#### Explanation:  
The `kubectl get pods` command lists pods filtered using label `role=master`.

The `kubectl get svc` command checks whether the Redis service is created.

We run these commands to ensure Redis Master is running and accessible.

### Step 4: Create Redis Slave Manifest  
```bash
cat > /tmp/redis-slave.yml << 'EOF'
# YAML content
EOF
```
#### Explanation:  
This command creates a YAML file for Redis Slave deployment and service. Redis Slaves replicate data from Redis Master.

We use this step to enable read scalability and fault tolerance.

### Step 5: Apply Redis Slave  
```bash
kubectl apply -f /tmp/redis-slave.yml
```
#### Explanation:  
This command deploys Redis Slave pods and services. It ensures replication is configured between master and slave nodes.

We run this command to complete the backend cluster.

### Step 6: Verify Redis Slaves  
```bash
kubectl get pods -l role=slave
kubectl get svc redis-slave
```
#### Explanation:  
The `kubectl get pods` command verifies that multiple slave pods are running.

The `kubectl get svc` command checks service availability.

We run this command to confirm scaling and replication setup.

### Step 7: Check Replication  
```bash
kubectl logs <slave-pod>
```
#### Explanation:  
The `kubectl logs` command retrieves logs from a running pod. We check logs to confirm that slaves successfully connected to the master. This ensures data synchronization is working.

### Step 8: Create Frontend Manifest  
```bash
cat > /tmp/frontend.yml << 'EOF'
# YAML content
EOF
```
#### Explanation:  
This command creates a YAML file for the frontend application. The frontend connects to Redis backend and serves the Guestbook UI.

We use this step to define application layer deployment.

### Step 9: Apply Frontend  
```bash
kubectl apply -f /tmp/frontend.yml
```
#### Explanation:  
This command deploys the frontend application pods and service. The service is exposed using NodePort for external access.

We run this command to make the app accessible.

### Step 10: Verify Frontend  
```bash
kubectl get pods -l tier=frontend
kubectl get svc frontend
```
#### Explanation:  
The `kubectl get pods` command verifies frontend pods are running.

The `kubectl get svc` command confirms NodePort exposure.

We run this command to ensure frontend availability.

### Step 11: Verify Full Deployment  
```bash
kubectl get all
```
#### Explanation:  
The `kubectl get all` command lists all Kubernetes resources. This includes pods, services, and deployments.

We run this command to confirm complete application deployment.

---

## Architecture Overview  

```
Frontend (NodePort Service)
        │
        ▼
Frontend Pods (3 replicas)
        │
        ▼
Redis Slave (Read)
        │
        ▼
Redis Master (Write)
```

---

## Config/YAML

### Reference YAML for Redis Master
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-master
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
      role: master
      tier: backend
  template:
    metadata:
      labels:
        app: redis
        role: master
        tier: backend
    spec:
      containers:
        - name: master-redis-devops
          image: redis
          ports:
            - containerPort: 6379
          resources:
            requests:
              cpu: 100m
              memory: 100Mi
---
apiVersion: v1
kind: Service
metadata:
  name: redis-master
spec:
  selector:
    app: redis
    role: master
    tier: backend
  ports:
    - protocol: TCP
      port: 6379
      targetPort: 6379
```

### Reference YAML for Redis Slave
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-slave
spec:
  replicas: 2
  selector:
    matchLabels:
      app: redis
      role: slave
      tier: backend
  template:
    metadata:
      labels:
        app: redis
        role: slave
        tier: backend
    spec:
      containers:
        - name: slave-redis-devops
          image: gcr.io/google_samples/gb-redisslave:v3
          ports:
            - containerPort: 6379
          resources:
            requests:
              cpu: 100m
              memory: 100Mi
          env:
            - name: GET_HOSTS_FROM
              value: dns
---
apiVersion: v1
kind: Service
metadata:
  name: redis-slave
spec:
  selector:
    app: redis
    role: slave
    tier: backend
  ports:
    - protocol: TCP
      port: 6379
      targetPort: 6379
```

### Reference YAML for Frontend
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: guestbook
      tier: frontend
  template:
    metadata:
      labels:
        app: guestbook
        tier: frontend
    spec:
      containers:
        - name: php-redis-devops
          image: gcr.io/google-samples/gb-frontend@sha256:a908df8486ff66f2c4daa0d3d8a2fa09846a1fc8efd65649c0109695c7c5cbff
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: 100m
              memory: 100Mi
          env:
            - name: GET_HOSTS_FROM
              value: dns
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  type: NodePort
  selector:
    app: guestbook
    tier: frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30009
```

---

## Key Learnings  

- Multi-tier apps are standard in production  
- Separation of concerns improves scalability  
- Kubernetes makes distributed systems manageable  
- Services enable communication between components  
