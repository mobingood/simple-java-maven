provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "example_sg" {
  name        = "example-security-group"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Replace with your AMI ID
  instance_type = "t2.micro"
  key_name      = "your-key" # Replace with your SSH key name
  security_groups = [aws_security_group.example_sg.name]

  tags = {
    Name = "AWS-Instance"
  }
}

## vshere deployment

provider "vsphere" {
  user           = "administrator@vsphere.local"
  password       = "your-password"
  vsphere_server = "your-vcenter-server"
  allow_unverified_ssl = true
}

resource "vsphere_virtual_machine" "vm" {
  name             = "VMware-Instance"
  resource_pool_id = "your-resource-pool-id"
  datastore_id     = "your-datastore-id"

  num_cpus = 2
  memory   = 4096
  guest_id = "other3xLinux64Guest" # Adjust for your OS type

  network_interface {
    network_id   = "your-network-id"
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    size             = 20
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = "your-template-uuid" # Replace with your VM template

    customize {
      linux_options {
        host_name = "vm-example"
        domain    = "local"
      }
      network_interface {
        ipv4_address = "192.168.1.100"
        ipv4_netmask = 24
      }
      ipv4_gateway = "192.168.1.1"
    }
  }
}



#############################################################

Multiple region deployment 


variable "regions" {
  type = list(string)
  default = [
    "us-east-1",
    "us-west-2",
    "eu-central-1",
    "ap-south-1",
    "eu-west-1",
    "ap-northeast-1",
    "sa-east-1",
    "ca-central-1",
    "ap-southeast-1",
    "me-south-1"
  ]
}

# Create provider aliases for each region
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

provider "aws" {
  alias  = "eu-central-1"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "ap-south-1"
  region = "ap-south-1"
}

provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "ap-northeast-1"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "sa-east-1"
  region = "sa-east-1"
}

provider "aws" {
  alias  = "ca-central-1"
  region = "ca-central-1"
}

provider "aws" {
  alias  = "ap-southeast-1"
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "me-south-1"
  region = "me-south-1"
}

# AMIs per region (must be valid and public)
locals {
  ami_map = {
    "us-east-1"       = "ami-0c02fb55956c7d316"
    "us-west-2"       = "ami-08962a4068733a2b6"
    "eu-central-1"    = "ami-0914547665e6a707c"
    "ap-south-1"      = "ami-03f4878755434977f"
    "eu-west-1"       = "ami-0a5e3b0f0e1f3d1b0"
    "ap-northeast-1"  = "ami-04b9e92b5572fa0d1"
    "sa-east-1"       = "ami-09e2b53bdb8f87c3d"
    "ca-central-1"    = "ami-005bdb005fb00e791"
    "ap-southeast-1"  = "ami-0d067f6f9d5c92b56"
    "me-south-1"      = "ami-053b0d53c279acc90"
  }
}

resource "aws_instance" "multi_region_instance" {
  for_each = toset(var.regions)

  ami           = local.ami_map[each.key]
  instance_type = "t2.micro"

  provider = aws[each.key]

  tags = {
    Name = "Instance-${each.key}"
  }
}



###################################################################################

10 instance with unique name : 


provider "aws" {
  region = "us-east-1"  # Change as needed
}

variable "instance_names" {
  default = [
    "instance-01", "instance-02", "instance-03", "instance-04", "instance-05",
    "instance-06", "instance-07", "instance-08", "instance-09", "instance-10"
  ]
}

resource "aws_instance" "multi_named" {
  for_each = toset(var.instance_names)

  ami           = "ami-0c02fb55956c7d316"  # Replace with your valid AMI
  instance_type = "t2.micro"

  tags = {
    Name = each.key
  }
}



