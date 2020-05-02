resource "aws_route53_record" "subdomain-dns" {
  zone_id = var.hosted_zone_id
  name    = var.subdomain_name
  type    = "CNAME"
  ttl     = "5"
  records = [aws_alb.main.dns_name]
}