resource "aws_route53_record" "primary" {
  zone_id        = var.route53_zone_id
  name           = "${var.subdomain}.${var.domain_name}"
  type           = "A"
  set_identifier = "primary-${var.subdomain}"

  alias {
    name                   = var.primary_load_balancer_dns_name
    zone_id                = var.primary_load_balancer_zone_id
    evaluate_target_health = true
  }

  failover_routing_policy {
    type = "PRIMARY"
  }
}

resource "aws_route53_record" "secondary" {
  zone_id        = var.route53_zone_id
  name           = "${var.subdomain}.${var.domain_name}"
  type           = "A"
  set_identifier = "secondary-${var.subdomain}"

  alias {
    name                   = var.secondary_load_balancer_dns_name
    zone_id                = var.secondary_load_balancer_zone_id
    evaluate_target_health = true
  }

  failover_routing_policy {
    type = "SECONDARY"
  }
}

resource "aws_route53_health_check" "primary" {
  fqdn              = var.primary_load_balancer_dns_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 2
  request_interval  = 10

  tags = {
    Name = "primary-health-check"
  }
}

resource "aws_route53_health_check" "secondary" {
  fqdn              = var.secondary_load_balancer_dns_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 2
  request_interval  = 10

  tags = {
    Name = "secondary-health-check"
  }
}