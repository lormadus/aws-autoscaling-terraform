variable "amazon_linux" {
# us-east-2 #us-east2 Amazon Linux 2 AMI (HVM), SSD Volume Type
# default 값일 뿐 참조안시키면 적용안됨
    default = "ami-0f7919c33c90f5b58" # us-east-2
}
variable "keyName" {
    default = "user10-terraform-key"
}
#확인 https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html
variable "alb_account_id" {
    # us-east-2
    default = "033677994240"
}
variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}

#폴더가 바뀌면 경로 수정
variable "PATH_TO_PRIVATE_KEY" {
  default = "/home/ec2-user/environment/id_rsa"
}
#폴더가 바뀌면 경로 수정
variable "PATH_TO_PUBLIC_KEY" {
  default = "/home/ec2-user/environment/id_rsa.pub"
}