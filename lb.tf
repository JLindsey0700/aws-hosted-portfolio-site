# Creates an instance target group which is used to route requests to targets.
resource "aws_lb_target_group" "web_server_tg" {
  name     = "Web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
  target_type = "instance"
  health_check {
    interval = 30
    path = "/"
    protocol = "HTTP"
    timeout = "5"
    healthy_threshold = "4"
    unhealthy_threshold = "2"   
  }
}

resource "aws_lb" "web_lb" {
    name = "WebLB"
    internal = "false"
    ip_address_type = "ipv4"
    load_balancer_type = "application"
    security_groups = [aws_security_group.lb_sg.id]
    subnets = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

# Creates an ALB listener on port 80 that listens for incoming HTTP traffic, and forwards it to the target group
resource "aws_lb_listener" "web_alb_listener" {
    load_balancer_arn = aws_lb.web_lb.arn
    port = 80
    protocol = "HTTP"
    default_action {
      target_group_arn = aws_lb_target_group.web_server_tg.arn
      type = "forward"
    }
}
