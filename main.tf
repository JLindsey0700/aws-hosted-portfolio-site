# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["/home/james/.aws/credentials"]
  profile = "iamadmin"
}

# Creates the main VPC 
resource "aws_vpc" "main_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "main_vpc"  
}
}

# Creates two public and private subnets
resource "aws_subnet" "public_a" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_a"
  }
}
resource "aws_subnet" "public_b" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
    tags = {
    Name = "public_b"
  }
}
resource "aws_subnet" "private_a" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private_a"
  }
}
resource "aws_subnet" "private_b" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private_b"
  }
}
# Creates IGW in main VPC
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main_igw"
  }
}
# Creates route table for main VPC
resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "main_RT"
  }
}
# Assosiates main rt with the main vpc
resource "aws_main_route_table_association" "rt_association" {
  vpc_id         = aws_vpc.main_vpc.id
  route_table_id = aws_route_table.main_rt.id
}
# Assosiates the subnets with the route table
resource "aws_route_table_association" "subnet-rt-pubA" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.main_rt.id
}
resource "aws_route_table_association" "subnet-rt-pubB" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.main_rt.id
}

# Creates public security group for the static web hosted EC2 instance
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Web Security Group"
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creates an EC2 instance which will host the static web site
resource "aws_instance" "static_website" {
  ami = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name = "staticwebserver"
  # Bootstrapping the EC2 instance with apache webserver, running systemctl manually with sudo seems to make it work
  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service 
systemctl enable httpd.service
echo “Hello World from $(hostname -f)” > /var/www/html/index.html"

EOF
  tags = {
    Name = "static_website"
  }
}