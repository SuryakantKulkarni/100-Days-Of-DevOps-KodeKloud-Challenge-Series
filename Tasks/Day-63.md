# Day 63 – Deploy Iron Gallery App on Kubernetes

---

## Task Overview
There is an iron gallery app that the Nautilus DevOps team was developing. They have recently customized the app and are going to deploy the same on the Kubernetes cluster. Below you can find more details:

- Create a namespace `iron-namespace-xfusion`

- Create a deployment `iron-gallery-deployment-xfusion` for iron gallery under the same namespace you created.

  - Labels `run` should be `iron-gallery`.

  - Replicas count should be `1`.

  - Selector's matchLabels `run` should be `iron-gallery`.

  - Template labels `run` should be `iron-gallery` under metadata.

  - The container should be named as `iron-gallery-container-xfusion`, use `kodekloud/irongallery:2.0` image ( use exact image name / tag ).

  - Resources limits for memory should be `100Mi` and for CPU should be `50m`.

  - First volumeMount name should be `config`, its mountPath should be `/usr/share/nginx/html/data`.

  - Second volumeMount name should be `images`, its mountPath should be `/usr/share/nginx/html/uploads`.

  - First volume name should be `config` and give it `emptyDir` and second volume name should be `images`, also give it `emptyDir`.

- Create a deployment `iron-db-deployment-xfusion` for `iron db` under the same namespace.

  - Labels `db` should be `mariadb`.

  - Replicas count should be `1`.

  - Selector's matchLabels `db` should be `mariadb`.

  - Template labels `db` should be `mariadb` under metadata.

  - The container name should be `iron-db-container-xfusion`, use `kodekloud/irondb:2.0 image` ( use exact image name / tag ).

  - Define environment, set `MYSQL_DATABASE` its value should be `database_blog`, set `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD` value should be with some complex passwords for DB connections, and `MYSQL_USER` value should be any custom user ( except root ).

  - Volume mount name should be `db` and its mountPath should be `/var/lib/mysql`. Volume name should be `db` and give it an `emptyDir`.

- Create a service for `iron db` which should be named `iron-db-service-xfusion` under the same namespace. Configure spec as selector's db should be `mariadb`. Protocol should be `TCP`, port and targetPort should be `3306`and its type should be `ClusterIP`.

- Create a service for `iron gallery` which should be named `iron-gallery-service-xfusion` under the same namespace. Configure spec as selector's run should be `iron-gallery`. Protocol should be `TCP`, port and targetPort should be 80, nodePort should be `32678` and its type should be `NodePort`.

- Note:
  - We don't need to make connection b/w database and front-end now, if the installation page is coming up it should be enough for now.
  - The kubectl on jump_host has been configured to work with the kubernetes cluster.

## Step-by-Step Implementation 

### Step 1: Create Namespace  
```bash
kubectl create namespace iron-namespace-xfusion
```
#### Explanation:
`kubectl create namespace` used to create a new namespace. A namespace is used to isolate resources inside the cluster.
We run this to keep all Iron Gallery app components organized and separate from other workloads.

## Step 2: Create Full Manifest File
```bash
cat > /tmp/iron-gallery.yml << 'EOF'
# YAML content
EOF
```
#### Explanation:
Creates a YAML file containing all Kubernetes resources (namespace, deployments, services).

## Step 3: Apply the Manifest
```bash
kubectl apply -f /tmp/iron-gallery.yml
```
#### Explanation:
`kubectl apply -f` reads the YAML file and creates resources in the cluster. It ensures all configurations are applied as defined.

## Step 4: Verify Namespace
```bash
kubectl get namespace iron-namespace-xfusion
```
#### Explanation:
`kubectl get namespace` lists namespaces. We use it to confirm that our namespace was created successfully.

## Step 5: Verify Deployments
```bash
kubectl get deployments -n iron-namespace-xfusion
```
#### Explanation:
`kubectl get deployments` shows deployment status. The `-n` flag specifies the namespace. We run this to check if application and database deployments are created and running.

## Step 6: Verify Pods
```bash
kubectl get pods -n iron-namespace-xfusion
```
#### Explanation:
`kubectl get pods` lists all running containers (pods). We use it to verify that pods are created and in running state.

## Step 7: Verify Services
```bash
kubectl get svc -n iron-namespace-xfusion
```
#### Explanation:
`kubectl get svc` lists services in the cluster. We run this to check if services are exposing the application correctly.

**Next Challenge**: [Day 64 →](Day-64.md)
