

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "WebLB-1283436870.us-east-1.elb.amazonaws.com"
  type    = "A"
  ttl     = 300
  records = []
}

resource "aws_route53_zone" "primary" {
  name = "jameslindsey.link"
}