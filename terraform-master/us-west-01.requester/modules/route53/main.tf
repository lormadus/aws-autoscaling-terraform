# DNS캐쉬문제로 콘솔에서 hosted_zone 먼저 만들고 유지해서 사용해야함
# resource "aws_route53_zone" "main" {
#   name = var.DOMAIN_NAME
#   comment = var.WHO_ARE_YOU
#   tags = {
#     Name = var.WHO_ARE_YOU
#   }
# }
locals {
  alb_count = length(var.ALBS)
}

resource "aws_route53_record" "a_type" {
  count  = local.alb_count

  zone_id = var.HOSTED_ZONE_ID
  name = "${var.AWS_REGION}.${var.WEB_SERVICE_PORTS[count.index]}.${var.DOMAIN_NAME}"
  type = "A"

  alias {
    name = var.ALBS[count.index].dns_name
    zone_id = var.ALBS[count.index].zone_id
    evaluate_target_health = false
  }
}

locals {
  continent_count = length(var.CONTINENT)
}
# locals {
#   continent_list = ["NA","SA"]
#   continent_list_count = length(local.continent_list)
# }
resource "aws_route53_record" "cname_type_dev" {
  count = local.continent_count
  zone_id = var.HOSTED_ZONE_ID
  name = "dev.${var.DOMAIN_NAME}"
  type = "CNAME"
  ttl  = 60
  records        = [aws_route53_record.a_type[1].name]

  # records        = ["${var.AWS_REGION}.80.${var.DOMAIN_NAME}","${var.AWS_REGION}.8080.${var.DOMAIN_NAME}"]
  
  geolocation_routing_policy {
    continent = var.CONTINENT[count.index]
    country   = "*"
  }

  set_identifier = "georouting-${var.AWS_REGION}-${var.CONTINENT[count.index]}"

}

resource "aws_route53_record" "cname_type_www" {
  count = local.continent_count
  zone_id = var.HOSTED_ZONE_ID
  name = "www.${var.DOMAIN_NAME}"
  type = "CNAME"
  ttl  = 60
  records        = [aws_route53_record.a_type[0].name]

  # records        = ["${var.AWS_REGION}.80.${var.DOMAIN_NAME}","${var.AWS_REGION}.8080.${var.DOMAIN_NAME}"]
  
  geolocation_routing_policy {
    continent = var.CONTINENT[count.index]
    country   = "*"
  }

  set_identifier = "georouting-${var.AWS_REGION}-${var.CONTINENT[count.index]}"

}
