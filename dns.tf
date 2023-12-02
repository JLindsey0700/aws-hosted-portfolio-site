# Imports a already created hosted zone a domain already registered in AWS Route53
data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name # root domain name
}

#Creates an Alias (A) record in the imported DNS hosted zone, pointing the domain name to the DNS name of the ALB
resource "aws_route53_record" "A_record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.domain_name  # root domain name
  type    = "A"
 
  alias {
    name                   = aws_lb.web_lb.dns_name
    zone_id                = aws_lb.web_lb.zone_id
    evaluate_target_health = false
  }
}
