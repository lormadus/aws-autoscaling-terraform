output "s3_object_uri" {
  value       = format("http://%s/%s", 
                        aws_cloudfront_distribution.images_cdn.domain_name,
                        aws_s3_bucket_object.images_cdn.key)
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.images_cdn.domain_name
}