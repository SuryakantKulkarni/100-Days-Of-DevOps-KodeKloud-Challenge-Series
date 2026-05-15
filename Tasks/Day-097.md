# Day 97 – Create IAM Policy Using Terraform

---

## Task Overview  
When establishing infrastructure on the AWS cloud, Identity and Access Management (IAM) is among the first and most critical services to configure. IAM facilitates the creation and management of user accounts, groups, roles, policies, and other access controls. The Nautilus DevOps team is currently in the process of configuring these resources and has outlined the following requirements.

Create an IAM policy named `iampolicy_kareem` in `us-east-1` region using Terraform. It must allow read-only access to the EC2 console, i.e., this policy must allow users to view all instances, AMIs, and snapshots in the Amazon EC2 console.

The Terraform working directory is `/home/bob/terraform`. Create the `main.tf` file (do not create a different `.tf` file) to accomplish this task.

`Note:` Right-click under the `EXPLORER` section in `VS Code` and select `Open in Integrated Terminal` to launch the terminal.

---

## Step-by-Step Implementation  

### Step 1: Open Terraform Working Directory  

```bash
cd /home/bob/terraform

pwd

ls -la
```
#### Explanation:  
The `cd` command changes current directory.  
The `pwd` command displays current path.  
The `ls -la` command lists all files including hidden files.  

We run these commands to verify Terraform working directory.

---

## 🔹 Create Terraform Configuration  

### Step 2: Open main.tf File  

```bash
vi main.tf
```
#### Explanation:  
The `vi` command opens file editor in terminal. We use this to add Terraform IAM configuration.

### Step 3: Add Terraform Configuration  

```hcl
resource "aws_iam_policy" "iampolicy_kareem" {
  name        = "iampolicy_kareem"
  description = "Read-only access to EC2 console"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeImages",
        "ec2:DescribeSnapshots",
        "ec2:DescribeVolumes",
        "ec2:DescribeTags",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeKeyPairs",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
```
#### Explanation:  
- `aws_iam_policy` creates IAM policy resource  
- `name` defines policy name  
- `description` explains policy purpose  
- `policy = <<EOF` starts multiline JSON policy block  
- `"Effect": "Allow"` grants permissions  
- `Describe*` actions provide read-only EC2 access  
- `"Resource": "*"` applies permissions to all resources  

We use this configuration to create secure read-only IAM access.

### Step 4: Save and Exit File  

```bash
Esc
:wq
```
#### Explanation:  
- `Esc` exits insert mode in vi editor  
- `:wq` writes changes and quits editor  

We save Terraform configuration before deployment.

---

## 🔹 Initialize and Validate Terraform  

### Step 5: Initialize Terraform Workspace  

```bash
terraform init
```
#### Explanation:  
The `terraform init` command initializes Terraform workspace. It downloads required AWS provider plugins and dependencies.  

We run this before Terraform operations.

### Step 6: Validate Terraform Configuration  

```bash
terraform validate
```
#### Explanation:  
The `terraform validate` command checks syntax and configuration correctness. We run this to detect configuration issues before deployment.

### Step 7: Preview Infrastructure Changes  

```bash
terraform plan
```
#### Explanation:  
The `terraform plan` command previews infrastructure resources. We run this to review planned changes safely.

---

## 🔹 Deploy Infrastructure  

### Step 8: Apply Terraform Configuration  

```bash
terraform apply -auto-approve
```
#### Explanation:  
The `terraform apply` command provisions AWS resources.  
- `-auto-approve` skips manual approval confirmation  

We run this to create IAM policy automatically.

---

## 🔹 Verify IAM Policy  

### Step 9: Verify Using AWS CLI  

```bash
aws iam list-policies --query "Policies[?PolicyName=='iampolicy_kareem']"
```
#### Explanation:  
The `aws iam list-policies` command lists IAM policies.  
- `--query` filters output using policy name  

We run this to confirm successful IAM policy creation.

### Step 10: Verify Policy Details  

```bash
aws iam get-policy --policy-arn <POLICY_ARN>
```
#### Explanation:  
The `get-policy` command displays detailed IAM policy information.  
- `policy-arn` identifies the IAM policy resource  

We run this to verify policy permissions and metadata.

---

## Key Learnings  
- IAM controls AWS authentication and authorization  
- Policies define allowed or denied AWS actions  
- Read-only policies improve security by limiting modifications  
- Terraform automates IAM resource provisioning  
- Infrastructure as Code improves consistency and auditability
