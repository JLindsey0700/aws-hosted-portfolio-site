/*
resource "aws_launch_template" "web_asg" {
  name_prefix   = "WebASG"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "bar" {
  availability_zones = ["us-east-1a", "us-east-1b"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template = {
    id      = "${aws_launch_template.foobar.id}"
    version = "$$Latest"
  }
}


resource "aws_ami_from_instance" "web_server_ami" {
    depends_on = [
      aws_instance.static_website
    ]
  name               = "WebServerAMI"
  source_instance_id = "static_website.id"
}

*/