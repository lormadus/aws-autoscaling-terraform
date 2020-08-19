## AWS CICD 샘플로 배포하시는 경우 Amazon LINUX 1세대 AMI 사용
variable "amazon_linux" {
  default = "ami-0ec225b5e01ccb706"
}

variable "dev_keyname" {
  default = "david-key"
}

## Region별 ALB Account ID 별도 지정
## https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html 
variable "alb_account_id" {
  default = "114774131450"
  
}
