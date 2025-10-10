#Terraform_2.tf

provider "aws" {
  region = "us-east-1"  # Change as needed
}

variable "ami_id" {
  default = "xxx" # Replace with actual AMI ID
}

variable "key_name" {
  default = "xxx" # Replace with actual key pair name (without .pem)
}

# Create 3 security groups
resource "aws_security_group" "sg" {
  count = 3
  name  = "custom-sg-${count.index + 1}"
  description = "Security group ${count.index + 1}"
  vpc_id = data.aws_vpc.default.id

  ingress {
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

  tags = {
    Name = "SG-${count.index + 1}"
  }
}

# Get default VPC and subnet
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Launch 5 EC2 instances
resource "aws_instance" "ec2" {
  count         = 5
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = element(data.aws_subnet_ids.default.ids, count.index % length(data.aws_subnet_ids.default.ids))
  key_name      = var.key_name

  security_groups = [
    aws_security_group.sg[0].name,
    aws_security_group.sg[1].name,
    aws_security_group.sg[2].name
  ]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              echo "hostname" >> /etc/hostname
              EOF

  root_block_device {
    volume_size = 100
    volume_type = "gp2"
  }

  tags = {
    Name = "Instance-${count.index + 1}"
  }
}

# Elastic IP for each EC2 instance
resource "aws_eip" "eip" {
  count      = 5
  instance   = aws_instance.ec2[count.index].id
  vpc        = true
}
