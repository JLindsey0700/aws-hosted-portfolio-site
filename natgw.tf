# Allocates elastic ip. This eip will be used for the nat-GW in the public subnet AZ-A
resource "aws_eip" "eip_for_natgw_AZ_A" {
  domain = "vpc"
  tags = {
    Name = "EIP for AZ A"
  }
}

# Allocates elastic ip. This eip will be used for the nat-GW in the public subnet AZ-B
resource "aws_eip" "eip_for_natgw_AZ_B" {
  domain = "vpc"

  tags   = {
    Name = "EIP for AZ B"
  }
}

# Creates nat-GW  in public subnet AZ-A
resource "aws_nat_gateway" "nat_gateway_AZ_A" {
  allocation_id = aws_eip.eip_for_natgw_AZ_A.id
  subnet_id     = aws_subnet.public_a.id

  tags   = {
    Name = "NatGW for Public Subnet A"
  }

  # Explicit dependency added on IGW to ensure proper ordering
  depends_on = [aws_internet_gateway.main_igw]
}

# Creates nat-GW  in public subnet AZ-B
resource "aws_nat_gateway" "nat_gateway_AZ_B" {
  allocation_id = aws_eip.eip_for_natgw_AZ_B.id
  subnet_id     = aws_subnet.public_b.id

  tags  = {
    Name    = "NatGW for Public SUbnet A"
  }

  # Explicit dependency added on IGW to ensure proper ordering
  depends_on = [aws_internet_gateway.main_igw]
}
