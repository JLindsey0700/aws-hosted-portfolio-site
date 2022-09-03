
# Creates an instance target group which are used to route requests to one or more registered targets.
resource "aws_lb_target_group" "web_server_tg" {
  name     = "TargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
  target_type = "instance"
  health_check {
    interval = 10
    path = "/"
    protocol = "HTTP"
    timeout = "5"
    healthy_threshold = "5"
    unhealthy_threshold = "2"   
  }
}

# Creates an application load balancer
resource "aws_lb" "application_lb" {
    name = "WebServerLoadBalancer"
    internal = "false"
    ip_address_type = "ipv4"
    load_balancer_type = "application"
    security_groups = [aws_security_group.web_sg.id]
    subnets = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

resource "aws_lb_listener" "web_alb_listener" {
    load_balancer_arn = aws_lb.application_lb.arn
    port = 80
    protocol = "HTTP"
    default_action {
      target_group_arn = aws_lb_target_group.web_server_tg.arn
      type = "forward"
    }
}

resource "aws_lb_target_group_attachment" "lb_targetgroup_attachment" {
  target_group_arn = aws_lb_target_group.web_server_tg.arn
  target_id        = aws_instance.static_website.id
  port             = 80
}


