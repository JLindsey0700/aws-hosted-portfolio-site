# Creates the main VPC 
resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "Main VPC"  
}
}

# Creates two public and private subnets
resource "aws_subnet" "public_a" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.pub_a_cidr
  availability_zone = var.availability_zone_a
  map_public_ip_on_launch = true
  tags = {
    Name = "Public A"
  }
}
resource "aws_subnet" "public_b" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.pub_b_cidr
  availability_zone = var.availability_zone_b
  map_public_ip_on_launch = true
    tags = {
    Name = "Public B"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.priv_a_cidr
  availability_zone = var.availability_zone_a
  tags = {
    Name = "Private A"
  }
}
resource "aws_subnet" "private_b" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.priv_b_cidr
  availability_zone = var.availability_zone_b
  tags = {
    Name = "Private B"
  }
}
# Creates IGW in main VPC
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "Main IGW"
  }
}

# Creates a route table to the IGW in the main VPC
resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "Main RT"
  }
}
# Assosiates main RT with the VPC
resource "aws_main_route_table_association" "rt_association" {
  vpc_id         = aws_vpc.main_vpc.id
  route_table_id = aws_route_table.main_rt.id
}
# Assosiates the public subnets with the route table
resource "aws_route_table_association" "subnet-rt-pubA" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.main_rt.id
}
resource "aws_route_table_association" "subnet-rt-pubB" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.main_rt.id
}


# Creates private route table AZ-A and add route through nat gateway AZ-A
resource "aws_route_table" "private_route_table_AZ_A" {
  vpc_id            = aws_vpc.main_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_AZ_A.id
  }

  tags   = {
    Name = "PrivateRT for AZ A"
  }
}

# Associates private subnet AZ-A with private route table AZ-A
resource "aws_route_table_association" "private_app_subnet_AZ_A_route_table_AZ_A_association" {
  subnet_id         = aws_subnet.private_a.id
  route_table_id    = aws_route_table.private_route_table_AZ_A.id
}

# Creates private route table AZ-B and add route through nat gateway AZ-B 
resource "aws_route_table" "private_route_table_AZ_B" {
  vpc_id            = aws_vpc.main_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_AZ_B.id
  }

  tags   = {
    Name = "PrivateRT for AZ B"
  }
}

# Associates private subnet AZ-B with private route table AZ-B
resource "aws_route_table_association" "private_app_subnet_AZ_B_route_table_AZ_B_association" {
  subnet_id         = aws_subnet.private_b.id
  route_table_id    = aws_route_table.private_route_table_AZ_B.id
}