resource "aws_autoscaling_group" "ASG_Group" {
  name                      = "Web ASG"
  depends_on = [aws_launch_configuration.Web_LT]  # ASG explicitly depends on the launch config referenced below, this line needs be added to avoid errors
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true # Allows deleting the ASG without waiting for all instances to terminate.
  launch_configuration      = aws_launch_configuration.Web_LT.id
  vpc_zone_identifier       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

resource "aws_launch_configuration" "Web_LT" {
  name                 = "Web LT"
  image_id             =  var.web_server_ami
  instance_type        = var.linux_instance_type
  iam_instance_profile = aws_iam_instance_profile.webserver_role.name # Attach IAM role to EC2 instance
  security_groups      = [aws_security_group.web_sg.id]  # Attach Web SG
  associate_public_ip_address = false # No public IP required as instances are launched in private subnets

  # Bash script installs Apache webserver, starts Apache, ensures it starts on system boot, then copies website files from an S3 bucket to document root directory 
  user_data          = <<EOF
#!/bin/bash
yum update -y                         
yum install -y httpd.x86_64           
sudo systemctl start httpd.service  
sudo systemctl enable httpd.service
sudo aws s3 cp s3://web-files-2343/ /var/www/html/ --recursive   
EOF
  lifecycle {
    create_before_destroy = true # Ensure a new launch configuration is created before destroying the existing one during updates or modifications
  }
}

#Attachs the ASG and the target group within the ALB
resource "aws_autoscaling_attachment" "asg_attachment_elb" {
  autoscaling_group_name = aws_autoscaling_group.ASG_Group.id
  lb_target_group_arn = aws_lb_target_group.web_server_tg.arn
}