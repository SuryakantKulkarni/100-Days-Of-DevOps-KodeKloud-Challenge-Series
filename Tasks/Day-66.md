# Day 66 – Deploy MySQL on Kubernetes

---

## Task Overview  
A new MySQL server needs to be deployed on Kubernetes cluster. The Nautilus DevOps team was working on to gather the requirements. Recently they were able to finalize the requirements and shared them with the team members to start working on it. Below you can find the details:

1. Create a PersistentVolume `mysql-pv`, its capacity should be `250Mi`, set other parameters as per your preference.

2. Create a PersistentVolumeClaim to request this PersistentVolume storage. Name it as `mysql-pv-claim` and request a `250Mi` of storage. Set other parameters as per your preference.

3. Create a deployment named `mysql-deployment`, use any mysql image as per your preference. Mount the PersistentVolume at mount path `/var/lib/mysql`.

4. Create a `NodePort` type service named `mysql` and set nodePort to `30007`.

5. Create a secret named `mysql-root-pass` having a key pair value, where key is `password` and its value is `YUIidhb667`, create another secret named `mysql-user-pass` having some key pair values, where frist key is `username` and its value is `kodekloud_rin`, second key is `password` and value is `BruCStnMT5`, create one more secret named `mysql-db-url`, key name is `database` and value is `kodekloud_db7`

6. Define some Environment variables within the container:

   - name: `MYSQL_ROOT_PASSWORD`, should pick value from secretKeyRef name: `mysql-root-pass` and key: `password`

   - name: `MYSQL_DATABASE`, should pick value from secretKeyRef name: `mysql-db-url` and key: `database`

   - name: `MYSQL_USER`, should pick value from secretKeyRef name: `mysql-user-pass` key key: `username`

   - name: `MYSQL_PASSWORD`, should pick value from secretKeyRef name: `mysql-user-pass` and key: `password`

> Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

---

## Step-by-Step Implementation  

### Step 1: Create Storage Directory  
```bash
mkdir -p /home/thor/pv
```
#### Explanation:
The `mkdir` command creates a directory on the host filesystem that will serve as the backing storage for the PersistentVolume.
- `-p` flag ensures parent directories are created if they don't exist and doesn't throw an error if the directory already exists.

This directory will store all MySQL database files, ensuring data persists even if the pod is deleted or recreated. 

### Step 2: Create Full Manifest
```bash
cat > /tmp/mysql-deployment.yml << 'EOF'
# YAML content
EOF
```
#### Explanation:
This command creates a YAML file using `cat`. In this file, we define Secrets, PV, PVC, Deployment, and Service. Keeping everything in one file makes it easier to manage and deploy all resources together.

Copy-Paste content from YAML File: [Day-66 YAML File →](Configs/Day-66-k8s-Deploy-MySQL.yaml)

### Step 3: Apply Manifest
```bash
kubectl apply -f /tmp/mysql-deployment.yml
```
#### Explanation:
The `kubectl apply -f` command reads the YAML file and apply the complete MySQL configuration to the Kubernetes cluster. It ensures that the cluster state matches the configuration in the file. We run this to deploy MySQL.

### Step 4: Verify Deployment
```bash
kubectl get deployments
```
#### Explanation:
The `kubectl get deployment` command check that the MySQL deployment was created successfully and has the desired number of replicas available. 

### Step 5: Verify Pods
```bash
kubectl get pods
```
#### Explanation:
The `kubectl get pods` command lists the pods created by the deployment. We run this to ensure the MySQL pod is in Running state with readiness 1/1.

### Step 6: Verify PV & PVC
```bash
kubectl get pv
kubectl get pvc
```
#### Explanation:
The `kubectl get pv` command displays the volume capacity (250Mi), access mode (RWO - ReadWriteOnce), reclaim policy, and claim reference. 

The `kubectl get pvc` command shows the requested storage, access modes, and which volume it's bound to.

We run these commands to verify the `PersistentVolume` was created and the `PersistentVolumeClaim` successfully bound to it. Both commands should show `STATUS: Bound`, indicating the claim has been matched with an available volume. 

### Step 7: Verify Service
```bash
kubectl get svc
```
#### Explanation:
The `kubectl get svc` command lists services in the kubernetes cluster. We run this to ensure the MySQL service was created with the correct type and port configuration.

### Step 8: Verify Secrets
```bash
kubectl get secrets
```
#### Explanation:
The `kubectl get secrets` command lists all secrets to confirm the three MySQL-related secrets were created: mysql-root-pass, mysql-user-pass, and mysql-db-url. 

We run this to ensure sensitive data is stored securely.

### Step 9: Test MySQL Connectivity
```bash
POD=$(kubectl get pods -l app=mysql -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $POD -- mysql -u root -p
```
#### Explanation:
The `POD=$(kubectl get pods -l app=mysql -o jsonpath='{.items[0].metadata.name}')` command assigns the name of a running MySQL pod to a variable called POD.
- `POD=`creates a shell variable and stores the value (pod name) to use later instead of typing manually.
- `kubectl get pods` command lists of all the pods running in the cluster.
- `-l` flag and `app=mysql` option filters the pods and returns only those that have the label app=mysql.
- `-o jsonpath='{.items[0].metadata.name}'` option extracts only the name of the first pod from the output instead of showing full details.
- `$()` syntax executes the command inside it and stores the result in the variable POD.

In simple terms, this command automatically finds the MySQL pod name and stores it so you don’t have to type it manually.

The `kubectl exec` command is used to run a command inside a running pod.
- `-i` flag keeps the input stream open so you can type into the container.
- `-t` flag allocates a terminal, allowing interactive commands like password input.
- `$POD` refers to the pod name stored in the previous step.
- `--` is a separator that tells Kubernetes that everything after it is the command to run inside the container.
- `mysql` is the MySQL client used to connect to the database.
- `-u` flag and `root` option specifies that you are logging in as the root user.
- `-p` flag prompts you to enter the password securely.

We run this command to connect to the MySQL database inside the running container.

After running this command, you will be asked to enter the password, and then you will enter the MySQL shell.

---

## Config / YAML
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-root-pass
type: Opaque
stringData:
  password: YUIidhb667
---
apiVersion: v1
kind: Secret
metadata:
  name: mysql-user-pass
type: Opaque
stringData:
  username: kodekloud_rin
  password: BruCStnMT5
---
apiVersion: v1
kind: Secret
metadata:
  name: mysql-db-url
type: Opaque
stringData:
  database: kodekloud_db7
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv
spec:
  capacity:
    storage: 250Mi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /home/thor/pv
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
        - name: mysql
          image: mysql:5.7
          ports:
            - containerPort: 3306
          env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-root-pass
                  key: password
            - name: MYSQL_DATABASE
              valueFrom:
                secretKeyRef:
                  name: mysql-db-url
                  key: database
            - name: MYSQL_USER
              valueFrom:
                secretKeyRef:
                  name: mysql-user-pass
                  key: username
            - name: MYSQL_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-user-pass
                  key: password
          volumeMounts:
            - name: mysql-storage
              mountPath: /var/lib/mysql
      volumes:
        - name: mysql-storage
          persistentVolumeClaim:
            claimName: mysql-pv-claim
---
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  type: NodePort
  selector:
    app: mysql
  ports:
    - port: 3306
      targetPort: 3306
      nodePort: 30007
```

---

## Key Learnings
- Stateful apps require persistent storage
- Secrets improve security
- PV & PVC enable data persistence
- Kubernetes supports full DB deployment
- Real-world production setup concept

---

**Next Challenge**: [Day 67 →]()
