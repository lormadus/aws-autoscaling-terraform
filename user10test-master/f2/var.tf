variable "amazon_linux" {
# eu-west-2 mazon Linux 2 AMI (HVM), SSD Volume Type
# 확인법 -AWS - 인스턴스 생성 - AMI이미지값확인
# default 값일 뿐 참조안시키면 적용안됨
    default = "ami-01a6e31ac994bbc09" # eu-west-2
}
variable "keyName" {
    default = "user10-terraform-key" # AWS 키페어에 보일 이름
}
#확인 https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html
variable "alb_account_id" {
    #eu-west2
    default = "652711504416" 
}

variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}

#home/ec2-user/.ssh/id_rsa에서 복사
#폴더가 바뀌면 경로 수정
variable "PATH_TO_PRIVATE_KEY" {
  default = "/home/ec2-user/environment/id_rsa"
}
#폴더가 바뀌면 경로 수정
variable "PATH_TO_PUBLIC_KEY" {
  default = "/home/ec2-user/environment/id_rsa.pub"
}