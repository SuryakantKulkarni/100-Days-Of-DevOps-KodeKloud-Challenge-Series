# Day 98 – Launch EC2 in Private VPC Subnet Using Terraform

---

## Task Overview  
The Nautilus DevOps team is expanding their AWS infrastructure and requires the setup of a private Virtual Private Cloud (VPC) along with a subnet. This VPC and subnet configuration will ensure that resources deployed within them remain isolated from external networks and can only communicate within the VPC. Additionally, the team needs to provision an EC2 instance under the newly created private VPC. This instance should be accessible only from within the VPC, allowing for secure communication and resource management within the AWS environment. 

- Create a VPC named `datacenter-priv-vpc` with the CIDR block `10.0.0.0/16`.

- Create a subnet named `datacenter-priv-subnet` inside the VPC with the CIDR block `10.0.1.0/24` and `auto-assign` IP option must not be `enabled.

- Create an EC2 instance named `datacenter-priv-ec2` inside the subnet and instance type must be `t2.micro`.

- Ensure the security group of the EC2 instance allows access only from within the VPC's CIDR block.

- Create the `main.tf` file (do not create a separate `.tf` file) to provision the VPC, subnet and EC2 instance.

- Use `variables.tf` file with the following variable names:

  - `KKE_VPC_CIDR` for the VPC CIDR block.
  - `KKE_SUBNET_CIDR` for the subnet CIDR block.
  
- Use the `outputs.tf` file with the following variable names:

  - `KKE_vpc_name` for the name of the VPC.
  - `KKE_subnet_name` for the name of the subnet.
  - `KKE_ec2_private` for the name of the EC2 instance.

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
The `pwd` command shows current directory path.  
The `ls -la` command lists all files including hidden files.  

We run these commands to verify Terraform workspace location.

---

## 🔹 Create Variables File  

### Step 2: Create variables.tf File  

```bash
vi variables.tf
```
#### Explanation:  
The `vi` command opens terminal text editor. We use this file to define reusable Terraform variables.

### Step 3: Add Variables Configuration  

```hcl
variable "KKE_VPC_CIDR" {
  default = "10.0.0.0/16"
}

variable "KKE_SUBNET_CIDR" {
  default = "10.0.1.0/24"
}
```
#### Explanation:  
- `variable` defines reusable Terraform variables  
- `KKE_VPC_CIDR` stores VPC CIDR range  
- `KKE_SUBNET_CIDR` stores subnet CIDR range  
- `default` assigns default network values  

We use variables for reusable and cleaner infrastructure code.

---

## 🔹 Create Main Terraform Configuration  

### Step 4: Create main.tf File  

```bash
vi main.tf
```
#### Explanation:  
The `vi` command opens the Terraform configuration file. We use this file to define AWS infrastructure resources.

### Step 5: Add Terraform Infrastructure Code  

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
    ec2 = "http://aws:4566"
  }
}

# Create VPC
resource "aws_vpc" "priv_vpc" {
  cidr_block = var.KKE_VPC_CIDR

  tags = {
    Name = "datacenter-priv-vpc"
  }
}

# Create Private Subnet
resource "aws_subnet" "priv_subnet" {
  vpc_id                  = aws_vpc.priv_vpc.id
  cidr_block              = var.KKE_SUBNET_CIDR
  map_public_ip_on_launch = false

  tags = {
    Name = "datacenter-priv-subnet"
  }
}

# Create Security Group
resource "aws_security_group" "priv_sg" {
  name   = "datacenter-priv-sg"
  vpc_id = aws_vpc.priv_vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.KKE_VPC_CIDR]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 Instance
resource "aws_instance" "priv_ec2" {
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.priv_subnet.id
  vpc_security_group_ids = [aws_security_group.priv_sg.id]

  tags = {
    Name = "datacenter-priv-ec2"
  }
}
```
#### Explanation:  
- `terraform` block defines required provider details  
- `provider "aws"` configures AWS region and endpoint  
- `aws_vpc` creates private VPC network  
- `cidr_block` defines VPC IP range  
- `aws_subnet` creates subnet inside VPC  
- `map_public_ip_on_launch = false` disables public IP assignment  
- `aws_security_group` creates firewall rules  
- `ingress` allows inbound traffic only from VPC CIDR  
- `egress` allows outbound traffic  
- `aws_instance` creates EC2 virtual machine  
- `instance_type = "t2.micro"` selects free-tier compatible instance  

We use this configuration to provision secure private AWS infrastructure.

---

## 🔹 Create Outputs File  

### Step 6: Create outputs.tf File  

```bash
vi outputs.tf
```
#### Explanation:  
The `vi` command opens outputs configuration file. We use outputs to display important resource values after deployment.

### Step 7: Add Outputs Configuration  

```hcl
output "KKE_vpc_name" {
  value = aws_vpc.priv_vpc.tags["Name"]
}

output "KKE_subnet_name" {
  value = aws_subnet.priv_subnet.tags["Name"]
}

output "KKE_ec2_private" {
  value = aws_instance.priv_ec2.tags["Name"]
}
```
#### Explanation:  
- `output` displays Terraform resource information  
- `value` retrieves resource tag values dynamically  

We use outputs for easier infrastructure verification.

---

## 🔹 Remove Duplicate Provider File (If Exists)

### Step 8: Check Existing Files  

```bash
ls
```
#### Explanation:  
The `ls` command lists all files in current directory. We run this to check if `provider.tf` already exists.

### Step 9: Remove provider.tf File  

```bash
rm -f provider.tf
```
#### Explanation:  
- `rm` removes files  
- `-f` force deletes file without confirmation  

We remove duplicate provider configuration to avoid Terraform conflicts.

---

## 🔹 Initialize and Validate Terraform  

### Step 10: Initialize Terraform  

```bash
terraform init
```
#### Explanation:  
The `terraform init` command initializes Terraform workspace. It downloads provider plugins and prepares backend files.  

We run this before Terraform operations.

### Step 11: Validate Configuration  

```bash
terraform validate
```
#### Explanation:  
The `terraform validate` command checks Terraform syntax and configuration validity. We run this to detect configuration errors early.

### Step 12: Preview Infrastructure Changes  

```bash
terraform plan
```
#### Explanation:  
The `terraform plan` command previews resources before deployment. We run this to verify infrastructure changes safely.

---

## 🔹 Deploy Infrastructure  

### Step 13: Apply Terraform Configuration  

```bash
terraform apply -auto-approve
```
#### Explanation:  
The `terraform apply` command creates AWS resources.  
- `-auto-approve` skips manual approval prompt  

We run this to provision infrastructure automatically.

---

## 🔹 Final Verification  

### Step 14: Verify Infrastructure State  

```bash
terraform plan
```
#### Explanation:  
The `terraform plan` command compares infrastructure with Terraform configuration. We run this to ensure infrastructure matches configuration exactly.

---

## Key Learnings  
- VPC provides isolated AWS private networking  
- Private subnets prevent automatic public internet exposure  
- Security groups control inbound and outbound traffic  
- Terraform variables improve reusable infrastructure code  
- Outputs help retrieve deployed resource information  
- Infrastructure as Code simplifies AWS automation  
