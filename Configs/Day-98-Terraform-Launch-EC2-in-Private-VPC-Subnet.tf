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
