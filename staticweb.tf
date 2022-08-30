# Creates an EC2 instance which will host the static web site
resource "aws_instance" "static_website" {
  ami = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_a.id        # Instance is placed in public subnet a 
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name = "staticwebserver"
  # Bootstrapping the EC2 instance with apache webserver
  iam_instance_profile = aws_iam_instance_profile.webserver_role.name
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


resource "aws_iam_instance_profile" "webserver_role" {
  name = "ec2_role_access_s3"
  role = aws_iam_role.ec2_iam_role.name
}
