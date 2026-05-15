# Day 95 – Create Security Group Using Terraform

---

## Task Overview  
The Nautilus DevOps team is strategizing the migration of a portion of their infrastructure to the AWS cloud. Recognizing the scale of this undertaking, they have opted to approach the migration in incremental steps rather than as a single massive transition. To achieve this, they have segmented large tasks into smaller, more manageable units. This granular approach enables the team to execute the migration in gradual phases, ensuring smoother implementation and minimizing disruption to ongoing operations. By breaking down the migration into smaller tasks, the Nautilus DevOps team can systematically progress through each stage, allowing for better control, risk mitigation, and optimization of resources throughout the migration process.

Use **Terraform** to create a security group under the default VPC with the following requirements:

- The name of the security group must be `devops-sg`.

- The description must be `Security group for Nautilus App Servers`.

- Add an inbound rule of type `HTTP`, with a port range of `80`, and source CIDR range `0.0.0.0/0`.

- Add another inbound rule of type `SSH`, with a port range of `22`, and source CIDR range `0.0.0.0/0`.

Ensure that the security group is created in the **us-east-1** region using Terraform. The Terraform working directory is `/home/bob/terraform`. Create the `main.tf` file (do not create a different `.tf` file) to accomplish this task.

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
The `pwd` command shows current path.  
The `ls -la` command lists all files and hidden files.  

We run these commands to verify Terraform working directory.

## 🔹 Create Terraform Configuration  

### Step 2: Open main.tf File  

```bash
vi main.tf
```
#### Explanation:  
The `vi` command opens file editor in terminal.  We use this to add Terraform configuration.

### Step 3: Add Terraform Configuration  

```hcl
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "devops_sg" {
  name        = "devops-sg"
  description = "Security group for Nautilus App Servers"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```
#### Explanation:  
- `data "aws_vpc"` fetches default VPC information  
- `resource "aws_security_group"` creates security group  
- `ingress` blocks define inbound rules  
- Port `80` allows HTTP traffic  
- Port `22` allows SSH traffic  
- `0.0.0.0/0` allows access from anywhere  
- `egress` block allows outbound traffic  

We use this configuration to create AWS network security rules.

### Step 4: Save and Exit File  

```bash
Esc
:wq
```
#### Explanation:  
- `Esc` exits insert mode  
- `:wq` saves changes and quits editor  

We save Terraform configuration before execution.

---

## 🔹 Initialize and Validate Terraform  

### Step 5: Initialize Terraform  

```bash
terraform init
```
#### Explanation:  
The `terraform init` command initializes Terraform workspace. It downloads required provider plugins and dependencies.  

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
The `terraform plan` command previews resources Terraform will create. We run this to review infrastructure changes safely.

---

## 🔹 Deploy Infrastructure  

### Step 8: Apply Terraform Configuration  

```bash
terraform apply -auto-approve
```
#### Explanation:  
The `terraform apply` command provisions infrastructure resources.  
- `-auto-approve` skips confirmation prompt automatically  

We run this to create the Security Group in AWS.

---

## 🔹 Verify Security Group  

### Step 9: Verify Using AWS CLI  

```bash
aws ec2 describe-security-groups --filters "Name=group-name,Values=devops-sg"
```
#### Explanation:  
The `aws ec2 describe-security-groups` command displays security group details.  
- `--filters` searches using group name  

We run this to confirm successful Security Group creation.

---

## Key Learnings  
- Terraform automates AWS security infrastructure  
- Security Groups control inbound and outbound traffic  
- `ingress` rules define allowed incoming traffic  
- `egress` rules define outgoing traffic behavior  
- Infrastructure as Code improves consistency and repeatability 
