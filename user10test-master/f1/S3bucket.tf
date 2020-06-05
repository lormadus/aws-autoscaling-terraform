resource "aws_s3_bucket" "user10_bucket_2" {
    bucket = "user10-bucket-2"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.alb_account_id}:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::user10-bucket-2/*"
        }
    ]
}
    EOF
    
    lifecycle_rule {
        id = "log_lifecycle"
        prefix = ""
        enabled = true
        
        transition {
            days = 30
            storage_class = "GLACIER"
        }
        
        expiration {
            days = 90
        }
    }
    
    lifecycle {
        prevent_destroy = false
    }
}
#아래에서 리전에 맞는 bucket IAM을 확인 후
# var.tf에서 alb_account_id 값 수정.
# "arn:aws:iam::${var.alb_account_id}:root"
# https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html
