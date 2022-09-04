
resource "aws_autoscaling_group" "ASG_Group" {
  name                      = "Web ASG"
  # We want this to explicitly depend on the launch config above
  depends_on = [aws_launch_configuration.Web_LT]
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.Web_LT.id
  vpc_zone_identifier       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}
resource "aws_launch_configuration" "Web_LT" {
  name          = "Web LT"
  image_id      =  var.web_server_ami
  instance_type = var.linux_instance_type
  iam_instance_profile = aws_iam_instance_profile.webserver_role.name # Attach S3 role to EC2 Instance
  security_groups    = [aws_security_group.web_sg.id]  # Attach Web SG
  user_data          = <<EOF
#!/bin/bash
yum update -y                         
yum install -y httpd.x86_64           
sudo systemctl start httpd.service    
sudo systemctl enable httpd.service
sudo aws s3 cp s3://web-files-2343/ /var/www/html/ --recursive   
EOF
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_attachment" "asg_attachment_elb" {
  autoscaling_group_name = aws_autoscaling_group.ASG_Group.id
  lb_target_group_arn = aws_lb_target_group.web_server_tg.arn
}

# Assings the prefined ec2 role to the ec2 iam instance profile which is assigned to the web server
resource "aws_iam_instance_profile" "webserver_role" {
  name = "ec2_role_access_s3"
  role = aws_iam_role.ec2_iam_role.name
}