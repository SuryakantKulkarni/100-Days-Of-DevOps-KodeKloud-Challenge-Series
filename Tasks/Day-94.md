# Day 94 – Create VPC Using Terraform

---

## Task Overview  
The Nautilus DevOps team is strategizing the migration of a portion of their infrastructure to the AWS cloud. Recognizing the scale of this undertaking, they have opted to approach the migration in incremental steps rather than as a single massive transition. To achieve this, they have segmented large tasks into smaller, more manageable units. This granular approach enables the team to execute the migration in gradual phases, ensuring smoother implementation and minimizing disruption to ongoing operations. By breaking down the migration into smaller tasks, the Nautilus DevOps team can systematically progress through each stage, allowing for better control, risk mitigation, and optimization of resources throughout the migration process.

Create a VPC named `nautilus-vpc` in region `us-east-1` with any `IPv4` CIDR block through terraform.

The Terraform working directory is `/home/bob/terraform`. Create the `main.tf` file (do not create a different `.tf` file) to accomplish this task.

`Note:` Right-click under the `EXPLORER` section in `VS Code` and select `Open in Integrated Terminal` to launch the terminal.

---

## Step-by-Step Implementation  

### Step 1: Open Terraform Working Directory in VS Code  

Open VS Code and navigate to:

```bash
/home/bob/terraform
```
#### Explanation:  
This is the Terraform working directory provided for the task. We use this location to create and manage Terraform configuration files.

### Step 2: Open Integrated Terminal  

- In VS Code left sidebar open `EXPLORER`  
- Right-click inside explorer area  
- Click `Open in Integrated Terminal`  

Now verify current path:

```bash
pwd
```

#### Explanation:  
The `pwd` command prints current working directory path. We run this to confirm terminal opened in correct Terraform directory.

---

## 🔹 Create Terraform Configuration  

### Step 3: Create main.tf File  

```bash
touch main.tf
```

#### Explanation:  
The `touch` command creates an empty file if it does not exist. We use this to create Terraform configuration file.

### Step 4: Open main.tf File  

```bash
vi main.tf
```

#### Explanation:  
The `vi` command opens file editor in terminal. We use this to add Terraform configuration.

---

## 🔹 Add Terraform Code  

### Step 5: Add Terraform Resource Configuration  

If `provider.tf` already exists, add ONLY this:

```hcl
resource "aws_vpc" "nautilus_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "nautilus-vpc"
  }
}
```

#### Explanation:  
- `resource "aws_vpc"` creates AWS VPC resource  
- `cidr_block` defines private network range  
- `tags` assigns readable resource name  

We use this configuration to provision AWS VPC infrastructure.

### Step 6: Alternative Configuration (If provider.tf Does Not Exist)  

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "nautilus_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "nautilus-vpc"
  }
}
```

#### Explanation:  
- `provider "aws"` configures AWS provider  
- `region = "us-east-1"` sets deployment region  
- Resource block creates the VPC  

We include provider block only when provider configuration is missing.

### Step 7: Save and Exit File  

```bash
Esc
:wq
```
#### Explanation:  
- `Esc` exits insert mode  
- `:wq` saves file and quits editor  

We save Terraform configuration before execution.

---

## 🔹 Initialize Terraform  

### Step 8: Initialize Terraform Workspace  

```bash
terraform init
```
#### Explanation:  
The `terraform init` command initializes Terraform workspace. It downloads provider plugins and prepares backend files.  

We run this before any Terraform operation.

### Step 9: Validate Terraform Configuration  

```bash
terraform validate
```
#### Explanation:  
The `terraform validate` command checks syntax and configuration correctness. We run this to detect errors before deployment.

### Step 10: Preview Infrastructure Changes  

```bash
terraform plan
```
#### Explanation:  
The `terraform plan` command previews infrastructure actions. We run this to verify resources before applying changes.

---

## 🔹 Deploy Infrastructure  

### Step 11: Apply Terraform Configuration  

```bash
terraform apply -auto-approve
```
#### Explanation:  
The `terraform apply` command creates infrastructure resources.  
- `-auto-approve` skips manual confirmation prompt  

We run this to provision AWS VPC automatically.

---

## 🔹 Verify VPC Creation  

### Step 12: Verify Using AWS CLI  

```bash
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=nautilus-vpc"
```
#### Explanation:  
The `aws ec2 describe-vpcs` command displays VPC details.  
- `--filters` searches VPC by Name tag  

We run this to confirm successful VPC creation.

---

## Key Learnings  
- Terraform automates AWS infrastructure deployment  
- Providers connect Terraform with cloud services  
- Resources define infrastructure components declaratively  
- `terraform plan` previews changes safely before deployment  
- Infrastructure as Code improves scalability and consistency 
