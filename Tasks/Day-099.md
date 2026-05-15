# Day 99 – Attach IAM Policy for DynamoDB Access Using Terraform

---

## Task Overview  
The DevOps team has been tasked with creating a secure DynamoDB table and enforcing fine-grained access control using IAM. This setup will allow secure and restricted access to the table from trusted AWS services only. 

As a member of the Nautilus DevOps Team, your task is to perform the following using Terraform: 

- **Create a DynamoDB Table:** Create a table named `xfusion-table with minimal configuration.

- **Create an IAM Role:** Create an IAM role named `xfusion-role` that will be allowed to access the table.

- **Create an IAM Policy:** Create a policy named `xfusion-readonly-policy` that should grant read-only access (GetItem, Scan, Query) to the specific DynamoDB table and attach it to the role.

- Create the `main.tf` file (do not create a separate `.tf` file) to provision the table, role, and policy.

- Create the `variables.tf` file with the following variables:

  - `KKE_TABLE_NAME:` name of the DynamoDB table
  - `KKE_ROLE_NAME:` name of the IAM role
  - `KKE_POLICY_NAME:` name of the IAM policy

- Create the `outputs.tf` file with the following outputs:

  - `kke_dynamodb_table:` name of the DynamoDB table
  - `kke_iam_role_name:` name of the IAM role
  - `kke_iam_policy_name:` name of the IAM policy

- Define the actual values for these variables in the `terraform.tfvars` file.

- Ensure that the `IAM policy` allows only read access and restricts it to the specific `DynamoDB table` created.

`Notes:` 

- The Terraform working directory is `/home/bob/terraform`.

- Right-click under the `EXPLORER` section in `VS Code` and select `Open in Integrated Terminal` to launch the terminal.

- Before submitting the task, ensure that `terraform plan` returns `No changes`. `Your infrastructure matches the configuration`.

---

## Step-by-Step Implementation  

### Step 1: Navigate to Terraform Directory  

```bash
cd /home/bob/terraform

pwd

ls -la
```
#### Explanation:  
The `cd` command changes current working directory.  
The `pwd` command displays current directory path.  
The `ls -la` command lists all files including hidden files.  

We run these commands to verify Terraform workspace.

---

## 🔹 Create Variables File  

### Step 2: Create variables.tf File  

```bash
vi variables.tf
```
#### Explanation:  
The `vi` command opens file editor in terminal. We use this file to define reusable Terraform variables.

### Step 3: Add Variables Configuration  

```hcl
variable "KKE_TABLE_NAME" {}

variable "KKE_ROLE_NAME" {}

variable "KKE_POLICY_NAME" {}
```
#### Explanation:  
- `variable` defines Terraform input variables  
- `KKE_TABLE_NAME` stores DynamoDB table name  
- `KKE_ROLE_NAME` stores IAM role name  
- `KKE_POLICY_NAME` stores IAM policy name  

We use variables for reusable and modular Terraform code.

---

## 🔹 Create terraform.tfvars File  

### Step 4: Create terraform.tfvars  

```bash
vi terraform.tfvars
```
#### Explanation:  
The `terraform.tfvars` file stores actual variable values. We use this to separate configuration from values.

### Step 5: Add Variable Values  

```hcl
KKE_TABLE_NAME  = "xfusion-table"
KKE_ROLE_NAME   = "xfusion-role"
KKE_POLICY_NAME = "xfusion-readonly-policy"
```
#### Explanation:  
These values are automatically loaded by Terraform during execution. We use this file for cleaner configuration management.

---

## 🔹 Create Main Terraform Configuration  

### Step 6: Create main.tf File  

```bash
vi main.tf
```
#### Explanation:  
The `vi` command opens Terraform configuration file. We use this file to define AWS infrastructure resources.

### Step 7: Add Terraform Infrastructure Code  

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    dynamodb = "http://aws:4566"
    iam      = "http://aws:4566"
  }
}

# Create DynamoDB Table
resource "aws_dynamodb_table" "xfusion_table" {
  name         = var.KKE_TABLE_NAME
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# Create IAM Role
resource "aws_iam_role" "xfusion_role" {
  name = var.KKE_ROLE_NAME

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Create IAM Policy
resource "aws_iam_policy" "readonly_policy" {
  name = var.KKE_POLICY_NAME

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = aws_dynamodb_table.xfusion_table.arn
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.xfusion_role.name
  policy_arn = aws_iam_policy.readonly_policy.arn
}
```
#### Explanation:  
- `terraform` block defines provider requirements  
- `provider "aws"` configures AWS region and endpoints  
- `aws_dynamodb_table` creates DynamoDB table  
- `billing_mode = "PAY_PER_REQUEST"` enables serverless billing  
- `hash_key` defines partition key  
- `attribute` defines table column type  
- `aws_iam_role` creates IAM role  
- `assume_role_policy` allows EC2 service to assume role  
- `jsonencode` converts Terraform map into JSON policy  
- `aws_iam_policy` creates custom IAM policy  
- `GetItem`, `Scan`, and `Query` provide read-only DynamoDB access  
- `Resource = aws_dynamodb_table.xfusion_table.arn` restricts access only to created table  
- `aws_iam_role_policy_attachment` attaches policy to IAM role  

We use this configuration to create secure DynamoDB access control.

---

## 🔹 Create Outputs File  

### Step 8: Create outputs.tf File  

```bash
vi outputs.tf
```
#### Explanation:  
The `vi` command opens Terraform outputs configuration file. We use outputs to display deployed resource details.

### Step 9: Add Outputs Configuration  

```hcl
output "kke_dynamodb_table" {
  value = aws_dynamodb_table.xfusion_table.name
}

output "kke_iam_role_name" {
  value = aws_iam_role.xfusion_role.name
}

output "kke_iam_policy_name" {
  value = aws_iam_policy.readonly_policy.name
}
```
#### Explanation:  
- `output` displays Terraform resource values  
- `value` fetches deployed resource names dynamically  

We use outputs for quick infrastructure verification.

---

## 🔹 Initialize and Validate Terraform  

### Step 10: Initialize Terraform Workspace  

```bash
terraform init
```
#### Explanation:  
The `terraform init` command initializes Terraform project. It downloads required provider plugins and dependencies.  

We run this before Terraform operations.

### Step 11: Validate Configuration  

```bash
terraform validate
```
#### Explanation:  
The `terraform validate` command checks Terraform syntax and configuration validity. We run this to identify configuration issues before deployment.

### Step 12: Preview Infrastructure Changes  

```bash
terraform plan
```
#### Explanation:  
The `terraform plan` command previews resources Terraform will create. We run this to safely review infrastructure changes.

---

## 🔹 Deploy Infrastructure  

### Step 13: Apply Terraform Configuration  

```bash
terraform apply -auto-approve
```
#### Explanation:  
The `terraform apply` command provisions AWS infrastructure.  
- `-auto-approve` skips manual approval confirmation  

We run this to deploy resources automatically.

---

## 🔹 Final Verification  

### Step 14: Verify Infrastructure State  

```bash
terraform plan
```
#### Explanation:  
The `terraform plan` command compares deployed infrastructure with configuration. We run this to confirm infrastructure matches Terraform code exactly.

---

## Key Learnings  
- DynamoDB is AWS fully managed NoSQL database service  
- IAM roles provide secure AWS service permissions  
- IAM policies define allowed AWS actions  
- Read-only policies improve AWS security posture  
- Terraform variables improve reusable infrastructure code  
- Outputs simplify infrastructure verification  moDB Access Using Terraform**  
