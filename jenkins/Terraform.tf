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
  count = 3
  key_name      = "your-key" # Replace with your SSH key name
  security_groups = [aws_security_group.example_sg.name,]

  tags = {
    Name = "AWS-Instance"
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
    Env = 

  }
}


# Create an EC2 instance with template 
resource "aws_instance" "web" {
  count         = 5 ## Number of instances 
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with valid AMI ID for your region
  instance_type = "t2.micro"

  # Use templatefile() to render the user data
  user_data = templatefile("${path.module}/userdata.sh.tftpl", {
    app_name    = var.app_name
    environment = var.environment
  })

  tags = {
    Name = "${var.app_name}-${var.environment}"
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


provider "aws" {
  region = var.region
}

# -----------------------------
# 1️⃣ Create VPC
# -----------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# -----------------------------
# 2️⃣ Create Subnets
# -----------------------------
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = {
    Name = "public-subnet-2"
  }
}

# -----------------------------
# 3️⃣ Create Internet Gateway
# -----------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# -----------------------------
# 4️⃣ Create Route Table and Associate
# -----------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# -----------------------------
# 5️⃣ Security Group for ALB
# -----------------------------
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.main.id

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

  tags = {
    Name = "alb-sg"
  }
}

# -----------------------------
# 6️⃣ Create Target Group
# -----------------------------
resource "aws_lb_target_group" "tg" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "alb-tg"
  }
}

# -----------------------------
# 7️⃣ Create Application Load Balancer
# -----------------------------
resource "aws_lb" "app_lb" {
  name               = "my-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "my-app-lb"
  }
}

# -----------------------------
# 8️⃣ Create Listener
# -----------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}



MultiZone Server with high avalialvltiy 

provider "aws" {
  region = "us-east-1"
}

# 1️⃣ Get Availability Zones
data "aws_availability_zones" "available" {}

# 2️⃣ Create a VPC
resource "aws_vpc" "multi_az_vpc" {
  cidr_block = "10.0.0.0/16"
}

# 3️⃣ Create Subnets in different AZs
resource "aws_subnet" "multi_az_subnets" {
  count             = 2
  vpc_id            = aws_vpc.multi_az_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.multi_az_vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

# 4️⃣ Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "multi-az-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.multi_az_vpc.id

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
}

# 5️⃣ Create EC2 Instances in multiple AZs
resource "aws_instance" "multi_az_instances" {
  count         = 2
  ami           = "ami-0c55b159cbfafe1f0" # Example: Amazon Linux 2
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.multi_az_subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "multi-az-instance-${count.index + 1}"
  }
}

# 6️⃣ (Optional) Load Balancer for HA
resource "aws_lb" "app_lb" {
  name               = "multi-az-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ec2_sg.id]
  subnets            = aws_subnet.multi_az_subnets[*].id
}
