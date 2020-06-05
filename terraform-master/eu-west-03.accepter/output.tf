# alb_auto_scaling module block
#------------------------------------------------------------------------------
output "alb_domain_names" {
	value = {
        for alb in module.alb_auto_scaling.alb:
        alb.name => alb.dns_name...
    }
}
#------------------------------------------------------------------------------


# web_images_cdn module block
#------------------------------------------------------------------------------
output "image_object_uri" {
	value = module.web_images_cdn.s3_object_uri
}

output "cloudfront_domain_name" {
	value = module.web_images_cdn.cloudfront_domain_name
}
#------------------------------------------------------------------------------

output "route53_web_url" {
	value = module.route53.web_url
}