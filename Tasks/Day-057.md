# Day 57 – Print Environment Variables

---

## Task Overview  
The Nautilus DevOps team is working on to setup some pre-requisites for an application that will send the greetings to different users. There is a sample deployment, that needs to be tested. Below is a scenario which needs to be configured on Kubernetes cluster. Please find below more details about it.

- Create a `pod` named `print-envars-greeting`.

- Configure spec as, the container name should be `print-env-container` and use `bash` image.

- Create three environment variables:

  - `GREETING` and its value should be `Welcome to`

  - `COMPANY` and its value should be `DevOps`

  - `GROUP` and its value should be `Ltd`

- Use command `["/bin/sh", "-c", 'echo "$(GREETING) $(COMPANY) $(GROUP)"']` (please use this exact command), also set its `restartPolicy` policy to `Never` to avoid crash loop back.

- You can check the output using `kubectl logs -f print-envars-greeting` command.

> Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

---

## Step-by-Step Implementation  

### Step 1: Create YAML File  
```bash
cat > /tmp/print-envars-greeting.yml << 'EOF'
# YAML content
EOF
```
#### Explanation:
The `cat` command with `>` creates a YAML file. We run this to define pod configuration and environment variables.

### Step 2: Apply YAML File
```bash
kubectl apply -f /tmp/print-envars-greeting.yml
```
#### Explanation:
`kubectl apply -f` reads the YAML file and creates the pod. We run this to deploy the pod in the cluster.

### Step 3: Verify Pod Status
```bash
kubectl get pod print-envars-greeting -w
```
#### Explanation:
- `-w` → watch pod status

We run this to observe pod lifecycle.
Pod will go from Running → Completed (expected behavior).

### Step 4: Check Output
```bash
kubectl logs -f print-envars-greeting
```
#### Explanation:
`kubectl logs` shows container output. We run this to verify that environment variables are printed correctly.

---

## Config / YAML
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: print-envars-greeting
spec:
  restartPolicy: Never
  containers:
    - name: print-env-container
      image: bash
      env:
        - name: GREETING
          value: "Welcome to"
        - name: COMPANY
          value: "DevOps"
        - name: GROUP
          value: "Ltd"
      command: ["/bin/sh", "-c", 'echo "$(GREETING) $(COMPANY) $(GROUP)"']
```

---

## Key Learnings
- Environment variables simplify configuration management
- Pods can be used for one-time execution tasks
- restartPolicy controls pod behavior
- Logs help verify output quickly
- This concept is widely used in real DevOps workflows
