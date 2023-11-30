# Allocates elastic ip. This eip will be used for the nat-GW in the public subnet az1
resource "aws_eip" "eip_for_natgw_az1" {
  domain = "vpc"
  tags = {
    Name = "EIP for AZ1"
  }
}

# Allocates elastic ip. This eip will be used for the nat-GW in the public subnet az1
resource "aws_eip" "eip_for_natgw_az2" {
  domain = "vpc"

  tags   = {
    Name = "EIP for AZ2"
  }
}

# Creates nat-GW  in public subnet az1
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_natgw_az1.id
  subnet_id     = aws_subnet.public_a.id

  tags   = {
    Name = "NatGW for Public Subnet A"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency on the internet gateway for the vpc.
  depends_on = [aws_internet_gateway.main_igw]
}

# Creates nat-GW  in public subnet az2
resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip_for_natgw_az2.id
  subnet_id     = aws_subnet.public_b.id

  tags  = {
    Name    = "NatGW for Public SUbnet A"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency on the internet gateway for the vpc.
  depends_on = [aws_internet_gateway.main_igw]
}

# Creates private route table az1 and add route through nat gateway az1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id            = aws_vpc.main_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az1.id
  }

  tags   = {
    Name = "PrivateRT for AZ1"
  }
}

# Associates private subnet az1 with private route table az1
resource "aws_route_table_association" "private_app_subnet_az1_route_table_az1_association" {
  subnet_id         = aws_subnet.private_a.id
  route_table_id    = aws_route_table.private_route_table_az1.id
}

# Creates private route table az2 and add route through nat gateway az2
resource "aws_route_table" "private_route_table_az2" {
  vpc_id            = aws_vpc.main_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az2.id
  }

  tags   = {
    Name = "PrivateRT for AZ2"
  }
}

# Associates private subnet az2 with private route table az2
resource "aws_route_table_association" "private_app_subnet_az2_route_table_az2_association" {
  subnet_id         = aws_subnet.private_b.id
  route_table_id    = aws_route_table.private_route_table_az2.id
}
