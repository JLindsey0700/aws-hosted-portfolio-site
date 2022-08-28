# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["/home/james/.aws/credentials"]
  profile = "iamadmin"
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
sudo systemctl start httpd.service 
sudo systemctl enable httpd.service
sudo echo “Hello World” > /var/www/html/index.html"
EOF
  tags = {
    Name = "static_website"
  }
}