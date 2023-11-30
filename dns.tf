# Imports the information from a prior created hosted zone for a domain already registered in AWS Route53
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

/*
resource "aws_route53_record" "NS_record" {
  allow_overwrite = true
  name            = var.domain_name
  ttl             = 60
  type            = "NS"
  zone_id         = aws_route53_zone.hosted_zone.zone_id
  # Manually setting the NS records in the  hosted zone, if not specfied the NS' will be chosen automatically and will not match the NS with the registrar
  records = [
    "ns-604.awsdns-11.net.",
    "ns-381.awsdns-47.com.",
    "ns-1223.awsdns-24.org.",
    "ns-1653.awsdns-14.co.uk.",
  ]
}
*/