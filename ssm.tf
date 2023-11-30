# Adds all the required VPC endpoints for SSM to function correctly
resource "aws_vpc_endpoint" "ssm_endpoint_1" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type = "Interface" 

  security_group_ids = [aws_security_group.ssm_endpoint_sg.id]
  subnet_ids         = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  private_dns_enabled = true  # Enables private DNS resolution for the endpoint
}

resource "aws_vpc_endpoint" "ssm_endpoint_2" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.ssm_endpoint_sg.id]
  subnet_ids         = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  private_dns_enabled = true  # Enable private DNS resolution for the endpoint
}

resource "aws_vpc_endpoint" "ssm_endpoint_3" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.us-east-1.ec2messages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.ssm_endpoint_sg.id]
  subnet_ids         = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  private_dns_enabled = true  # Enable private DNS resolution for the endpoint
}

