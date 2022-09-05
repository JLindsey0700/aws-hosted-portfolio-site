/*
resource "aws_route53_zone" "primary" {
  name = "jameslindsey.link"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "Portfolio_Site"
  type    = "A"

  alias {
    name                   = aws_lb.web_lb.dns_name
    zone_id                = aws_lb.web_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "Portfolio_Site"
  type    = "A"
  ttl     = 300
  records = [aws_lb.web_lb.dns_name]
}
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "WebLB-1283436870.us-east-1.elb.amazonaws.com"
  type    = "A"
  ttl     = 300
  records = [aws_lb.web_lb.id]
}




resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "WebLB-1283436870.us-east-1.elb.amazonaws.com"
  type    = "A"
  ttl     = 300
  records = []
}
*/

# Adds A records for the ALB 
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "jameslindsey.link"
  type    = "A"

  alias {
    name                   = aws_lb.web_lb.dns_name
    zone_id                = aws_lb.web_lb.zone_id
    evaluate_target_health = false
  }
}

#Creates the R53 zone for jameslindsey.link
resource "aws_route53_zone" "primary" {
  name = "jameslindsey.link"
}


# Adds NS records for the NS assosiated with the registered domain to the R53 Zone
resource "aws_route53_record" "ns" {
  allow_overwrite = true
  name            = "jameslindsey.link"
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.primary.zone_id

  records = ["ns-542.awsdns-03.net", "ns-1238.awsdns-26.org", "ns-1693.awsdns-19.co.uk", "ns-468.awsdns-58.com"]
}

