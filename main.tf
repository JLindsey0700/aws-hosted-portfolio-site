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
resource "aws_vpc" "main-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "main-vpc"
  }
}
# Creates two public and private subnets
resource "aws_subnet" "public-a" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.0.0/26"

  tags = {
    Name = "public-a"
  }
}
resource "aws_subnet" "public-b" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.0.64/26"

  tags = {
    Name = "public-b"
  }
}
resource "aws_subnet" "private-a" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.0.128/26"

  tags = {
    Name = "private-a"
  }
}
resource "aws_subnet" "private-b" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.0.192/26"

  tags = {
    Name = "private-b"
  }
}
# Creates IGW in main VPC
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-igw"
  }
}
# Attaches IGW to main VPC
resource "aws_internet_gateway_attachment" "igw-vpc" {
  internet_gateway_id = aws_internet_gateway.main-igw.id
  vpc_id              = aws_vpc.main-vpc.id
}
# Creates route table for main VPC
resource "aws_route_table" "main-rt" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
  tags = {
    Name = "example"
  }
}
# Assosiates the subnets with the route table
resource "aws_route_table_association" "subnet-rt-pubA" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.main-rt.id
}
resource "aws_route_table_association" "subnet-rt-pubB" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.main-rt.id
}