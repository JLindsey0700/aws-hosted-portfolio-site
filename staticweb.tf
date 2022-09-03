/*
# Creates an EC2 instance which will host the static web site
resource "aws_instance" "static_website" {
  ami = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_a.id        # Instance is placed in public subnet a 
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name = "staticwebserver"
  # Bootstrapping the EC2 instance with the apache webserver application
  iam_instance_profile = aws_iam_instance_profile.webserver_role.name
  user_data = <<EOF
#!/bin/bash
yum update -y                         
yum install -y httpd.x86_64           
sudo systemctl start httpd.service    
sudo systemctl enable httpd.service
sudo aws s3 cp s3://web-files-2343/ /var/www/html/ --recursive   
EOF
  tags = {
    Name = "static_website"
  
  }
}
*/

# Assings the prefined ec2 role to the ec2 iam instance profile which is assigned to the web server
resource "aws_iam_instance_profile" "webserver_role" {
  name = "ec2_role_access_s3"
  role = aws_iam_role.ec2_iam_role.name
}


# Create an EFS, web files will be stored & the storage will be mounted to the instances running apache. 
resource "aws_efs_file_system" "efs_webfiles" {
  creation_token = "efs_web_server_files"

  tags = {
    Name = "Web_EFS"
  }
}

/*
resource "aws_efs_mount_target" "mount" {
  file_system_id = aws_efs_file_system.efs_webfiles.id
  subnet_id      = aws_subnet.public_a.id
  security_groups = []
}
*/

