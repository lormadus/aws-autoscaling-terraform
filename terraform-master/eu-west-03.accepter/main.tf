#------------------------------------------------------------------------------
provider "aws" {
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  region     = var.AWS_REGION
}

resource "aws_key_pair" "public_key" {
  key_name   = "${var.WHO_ARE_YOU}_public_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

locals {
  #peering_id = module.vpc_peering_requester.id # for vpc-peering requester
  peering_id = "pcx-09322e011dac7ac38"        # for vpc-peering accepter # 두번째
}

###############################################################################
# terraform 코드를 module화 및 자동화
#
# ㅇ VPC : Region의 Available Zone 전체수에 맞게 frontend, backend(nat옵션)등 자동생성
# ㅇ security group : security group rule를 별도 생성하여 서비스 포트만 허용
# ㅇ VPC peering : 반자동화
# ㅇ cloudfront, S3 bucket 
#   - 생성과 bucket object(image) 자동 업로드후 cloudfront URI 자동 배포  
# ㅇ route53 : 
# ㅇ Application Loadbalancer : 80리슨 8080타켓 그룹  
# ㅇ Autoscailing : 
#   - KPI-"ALB requests per targer"기준 Target Tracking scaling Policy 적용 
###############################################################################
#------------------------------------------------------------------------------
module "vpc" {
    
    source                      = "./modules/vpc" 
    
    VPC_CIDR                    = var.VPC_CIDR
    FRONTEND_SUBNET_COUNT       = var.FRONTEND_SUBNET_COUNT
    BACKEND_SUBNET_COUNT        = var.BACKEND_SUBNET_COUNT
    ENABLE_BACKEND_SUBNET       = var.ENABLE_BACKEND_SUBNET
    WHO_ARE_YOU                 = var.WHO_ARE_YOU

    #VPC-Peer할 때만 활성화 할 것
    PEER_CIDR                   = var.PEER_VPC_CIDR
    PEER_ID                     = local.peering_id
}

module "security_group_policy" {
    
    source                      = "./modules/security-group-policy" 
    
    VPC_ID                      = module.vpc.id
    WEB_SERVICE_PORTS           = var.WEB_SERVICE_PORTS #80,8080
    SSH_ACCESS_CIDR             = var.SSH_ACCESS_CIDR
    WHO_ARE_YOU                 = var.WHO_ARE_YOU
}

module "route53" { 
    
    source                      = "./modules/route53" 

    HOSTED_ZONE_ID              = var.HOSTED_ZONE_ID
    
    ALBS                        = module.alb_auto_scaling.alb
    WEB_SERVICE_PORTS           = var.WEB_SERVICE_PORTS
    # ALB_DNS_NAME                = module.alb_auto_scaling.alb_domain_name
    # ALB_ZONE_ID                 = module.alb_auto_scaling.alb_zone_id
    
    AWS_REGION                  = var.AWS_REGION
    WHO_ARE_YOU                 = var.WHO_ARE_YOU

    DOMAIN_NAME                 = var.DOMAIN_NAME
    CONTINENT                   = var.CONTINENT #geo routing policy to routing53
}

module "web_images_cdn" { #cloudfront
    
    source                      = "./modules/cloudfront" 

    IMAGES_BUCKET_NAME          = "${var.WHO_ARE_YOU}-web-images-${var.AWS_REGION}"
    BUCKET_OBJECT               = "images/iu.gif"
    LOG_BUCKET_NAME             = "${var.WHO_ARE_YOU}-cf-log-${var.AWS_REGION}"
    WHO_ARE_YOU                 = var.WHO_ARE_YOU

}

module "alb_auto_scaling" {
    
    source                      = "./modules/alb-auto-scaling" 

    //사용포트지정
    WEB_SERVICE_PORTS           = var.WEB_SERVICE_PORTS

    # for ALB
    VPC_ID                      = module.vpc.id
    ALB_AUTO_SCALING_SUBNETS    = [for s in module.vpc.frontend_subnets : s.id]
    ALB_SECURITY_GROUPS         = module.security_group_policy.alb_sgs
    ALB_LOG_BUCKET_NAME         = "${var.WHO_ARE_YOU}-alb-log-${var.AWS_REGION}"
    ALB_ACCOUNT_ID              = lookup(var.ALB_ACCOUNT_ID, var.AWS_REGION)

    # instance templete config
    INSTANCE_IMAGE_ID           = lookup(var.AMIS, var.AWS_REGION)
    INSTANCE_TYPE               = "t2.micro"
    WEB_SECURITY_GROUPS         = module.security_group_policy.web_server_sgs
    SSH_SECURITY_GROUP          = module.security_group_policy.ssh_sgi
    PUBLIC_KEY_NAME             = aws_key_pair.public_key.key_name
    CDN_IMAGE_URI               = module.web_images_cdn.s3_object_uri #인라인으로 배포
    AWS_REGION                  = var.AWS_REGION  #인라인으로 배포
    
    # for auto-scaling-group
    AUTO_SCALE_MIN_SIZE         = 1
    AUTO_SCALE_MAX_SIZE         = 3
    DESIRED_CAPACITY            = 2

    # for tagging
    WHO_ARE_YOU                 = var.WHO_ARE_YOU

}


# [주의!] 
# 0. 동일 코드를 두개의 폴더로 분리 peer1, peer2
# 1. peer2는 vpc_peering모듈X, vpc일부 코드 실행차단, variables.tf 수정
# 2. peer2 리전의 VPC 및 구성을 먼저 생성후
# 3. 아래 코드 활성화후 peer1 수행
# 4. terraform apply : peer1은 자동으로 완료
# 5. peer2 리전에서 수동으로 accept 수행
# 6. peer2 vpc추가 코드 활성화후 다시 적용 
/*
module "vpc_peering_requester" { //accepter는 실행하지 말것!!!
    
    source                      = "./modules/vpc-peering-requester" 
    
    AWS_ACCESS_KEY              = var.AWS_ACCESS_KEY
    AWS_SECRET_KEY              = var.AWS_SECRET_KEY
    VPC_ID                      = module.vpc.id
    
    PEER_AWS_REGION             = var.PEER_AWS_REGION
    PEER_VPC_CIDR               = var.PEER_VPC_CIDR
    
    WHO_ARE_YOU                 = var.WHO_ARE_YOU
}
output "peering_id" {
  value = module.vpc_peering_requester.id
}
*/
