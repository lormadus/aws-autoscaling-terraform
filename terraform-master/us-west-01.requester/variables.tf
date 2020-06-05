variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
  default = "us-west-1"
}

variable "PEER_AWS_REGION" {
  default = "eu-west-3"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "~/.ssh/id_rsa.pub"
}

variable "VPC_CIDR" {
  default = "11.0.0.0/16"
}

variable "PEER_VPC_CIDR" {
  default = "111.0.0.0/16"
}

variable "FRONTEND_SUBNET_COUNT" {
  default = 2
}

variable "BACKEND_SUBNET_COUNT" {
  default = 0
}

variable "ENABLE_BACKEND_SUBNET" {
  default = false
}

#301.5G_A WiFi
variable "SSH_ACCESS_CIDR" {
  default = "59.13.4.75/32"
}

variable "WEB_SERVICE_PORTS" {
  default = ["80", "8080"]
}

variable "AMIS" {
  default = {
    us-west-1      = "ami-0f56279347d2fa43e" #캘리포니아
    eu-west-1      = "ami-0dad359ff462124ca" #아일랜드
    eu-west-3      = "ami-08c757228751c5335" #파리
    ap-northeast-2 = "ami-00edfb46b107f643c" #서울
  }
}

variable "ALB_ACCOUNT_ID" {
    default = {
      us-west-1       = "027434742980" #캘리포니아
      eu-west-3       = "009996457667" #파리
      ap-northeast-2  = "600734575887" #서울
    }
}

variable "HOSTED_ZONE_ID" {
  default = "Z0592988313227VEFX5E8"
}

variable "DOMAIN_NAME" {
  default = "kiunsen.site"
}

#ALB생성 Region에 따른 A-record가 geo routing할 대상 대륙 지정 
variable "CONTINENT" {
  default = ["NA", "SA", "AS"]

# eu-west-03
# AF: Africa
# AN: Antarctica
# EU: Europe
# OC: Oceania

# us-west-01
# AS: Asia
# NA: North America
# SA: South America  
}

variable "WHO_ARE_YOU" {
  default = "user11"
}

