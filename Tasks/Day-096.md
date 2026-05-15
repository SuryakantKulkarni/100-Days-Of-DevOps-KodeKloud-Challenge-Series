# Day 96 – Create EC2 Instance Using Terraform

---

## Task Overview  
The Nautilus DevOps team is strategizing the migration of a portion of their infrastructure to the AWS cloud. Recognizing the scale of this undertaking, they have opted to approach the migration in incremental steps rather than as a single massive transition. To achieve this, they have segmented large tasks into smaller, more manageable units.

For this task, create an EC2 instance using `Terraform` with the following requirements:

- The EC2 instance must use the value `datacenter-ec2` as its Name tag, which defines the instance name in AWS.

- Use the `Amazon Linux` `ami-0c101f26f147fa7fd` to launch this instance.

- The Instance type must be `t2.micro`.

- Create a new RSA key named `datacenter-kp`.

- Attach the default (available by default) security group.

The Terraform working directory is `/home/bob/terraform`. Create the `main.tf` file (do not create a different `.tf` file) to provision the instance.

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
The `vi` command opens the Terraform configuration file editor. We use this to add AWS EC2 infrastructure code.

### Step 3: Add Terraform Configuration  

```hcl
resource "tls_private_key" "datacenter_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "datacenter_kp" {
  key_name   = "datacenter-kp"
  public_key = tls_private_key.datacenter_key.public_key_openssh
}

data "aws_security_group" "default" {
  name = "default"
}

resource "aws_instance" "datacenter_ec2" {
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.datacenter_kp.key_name
  vpc_security_group_ids = [data.aws_security_group.default.id]

  tags = {
    Name = "datacenter-ec2"
  }
}
```
#### Explanation:  
- `tls_private_key` creates RSA private/public key pair  
- `algorithm = "RSA"` defines encryption type  
- `rsa_bits = 4096` creates stronger key security  
- `aws_key_pair` uploads public key to AWS  
- `data "aws_security_group"` fetches default security group  
- `aws_instance` creates EC2 instance  
- `ami` defines operating system image  
- `instance_type` sets EC2 hardware size  
- `key_name` attaches SSH key pair  
- `tags` assigns EC2 instance name  

We use this configuration to provision secure EC2 infrastructure.

### Step 4: Save and Exit File  

```bash
Esc
:wq
```
#### Explanation:  
- `Esc` exits insert mode in vi editor  
- `:wq` writes changes and quits editor  

We save Terraform configuration before execution.

---

## 🔹 Initialize and Validate Terraform  

### Step 5: Initialize Terraform Workspace  

```bash
terraform init
```
#### Explanation:  
The `terraform init` command initializes Terraform project. It downloads required AWS and TLS provider plugins.  

We run this before Terraform operations.

### Step 6: Validate Terraform Configuration  

```bash
terraform validate
```
#### Explanation:  
The `terraform validate` command checks syntax and configuration validity. We run this to detect errors before deployment.

### Step 7: Preview Infrastructure Changes  

```bash
terraform plan
```
#### Explanation:  
The `terraform plan` command previews resources Terraform will create. We run this to review infrastructure safely before deployment.

---

## 🔹 Deploy Infrastructure  

### Step 8: Apply Terraform Configuration  

```bash
terraform apply -auto-approve
```
#### Explanation:  
The `terraform apply` command provisions AWS resources.  
- `-auto-approve` skips confirmation prompt automatically  

We run this to create EC2 instance and key pair.

---

## 🔹 Verify EC2 Instance  

### Step 9: Verify Using AWS CLI  

```bash
aws ec2 describe-instances --filters "Name=tag:Name,Values=datacenter-ec2"
```
#### Explanation:  
The `aws ec2 describe-instances` command displays EC2 instance details.  
- `--filters` searches instance using Name tag  

We run this to confirm successful EC2 creation.

### Step 10: Verify Key Pair  

```bash
aws ec2 describe-key-pairs --key-names datacenter-kp
```
#### Explanation:  
The `describe-key-pairs` command checks AWS key pair details. We run this to verify key pair creation.

---

## Key Learnings  
- Terraform automates EC2 infrastructure provisioning  
- Key pairs provide secure SSH authentication  
- AMIs define operating system templates  
- Security groups control instance network access  
- Infrastructure as Code improves repeatability and scalability
