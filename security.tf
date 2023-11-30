# Creates Security Group for HTTP, HTTPS ingress traffic to the instances hosting Apache, and allows all egress traffic
resource "aws_security_group" "web_sg" {
  name        = "Web SG"
  description = "Security Group for instance web traffic"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }  
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTPS connections"
  }  

/*  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
  }  
  */

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Creates Security Group for HTTP & HTTPS ingress traffic to the application load balancer, and allows all egress traffic
resource "aws_security_group" "lb_sg" {
  name        = "Load Balancer SG"
  description = "Security Group for load balancer"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }  
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTPS connections"
  }  
    
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssm_endpoint_sg" {
  name        = "ssm-endpoint-sg"
  description = "Security group for VPC endpoints for SSM"

  vpc_id = aws_vpc.main_vpc.id 

  # Inbound rules to allow communication with Systems Manager service
  ingress {
    from_port   = 443 
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows inbound traffic from all IPv4 addresses
    description = "Inbound traffic for Systems Manager"
  }

  # Outbound rule allowing responses from Systems Manager to the endpoint
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound traffic to all IPv4 addresses
    description = "Outbound traffic for Systems Manager"
  }
}
