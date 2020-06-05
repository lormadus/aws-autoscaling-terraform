# VPC
resource "aws_vpc" "user10_r2_vpc" {
    cidr_block = "110.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    instance_tenancy = "default"
    tags = {
      Name = "user10_r2_vpc"
    }
}

# Subnet
resource "aws_subnet" "user10_r2_sub1" {
    #vpc변수명으로 변경
    vpc_id = aws_vpc.user10_r2_vpc.id
    availability_zone = "eu-west-2a"
    cidr_block = "110.0.1.0/24"
    tags = {
        Name = "user10_r2_sub1"
    }
}
resource "aws_subnet" "user10_r2_sub2" {
     vpc_id = aws_vpc.user10_r2_vpc.id
    #aws에서 AZ 확인가능
    #수정 
    availability_zone = "eu-west-2b"
    #수정 
    cidr_block = "110.0.2.0/24"
    #수정
    tags = {
        Name = "user10_r2_sub2"
    }
}
# 인터넷 게이트웨이
resource "aws_internet_gateway" "user10_r2_igw" {
    #vpc변수명으로 변경
    vpc_id = aws_vpc.user10_r2_vpc.id
   
    tags = {
        Name = "user10_r2_igw"
    }
}

# user10_routing_table
resource "aws_route_table" "user10_r2_igw_rt" {
    vpc_id = aws_vpc.user10_r2_vpc.id
    #VPC Peering  관련 Routing Table에서 아래 수정 추가 (VPC1, VPC2 모두 적용)
    #여긴 먼저 주석처리부터하고 시작
    route {
        cidr_block = "10.0.0.0/16"
        gateway_id = "pcx-0c194a0904878e2f5"#피어링연결 PCX 값을 가지고 함.r2돌리고 peer VPC 값을 r1 subnet에 추가 후 
        #r1 돌리고 r1의 peer링연결 pcx값 직접입력 
    }
    route {
       cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.user10_r2_igw.id
    }
    #수정 
    tags = {
        Name = "user10_r2_igw_rt"
    }
}
# route associations
resource "aws_route_table_association" "user10_r2_igw_rt_1" {
    subnet_id = aws_subnet.user10_r2_sub1.id
    route_table_id = aws_route_table.user10_r2_igw_rt.id
}

resource "aws_route_table_association" "user10_r2_igw_rt_2" {
    subnet_id = aws_subnet.user10_r2_sub2.id
    route_table_id = aws_route_table.user10_r2_igw_rt.id
}
# NAT Gateway - r2 - ins1
#resource "aws_nat_gateway" "user10_r2_sub1_nat" {
#    allocation_id = aws_eip.user10_r2_sub1_nat_eip.id
#    subnet_id = aws_subnet.user10_r2_sub1.id
#}
# EIP
#resource "aws_eip" "user10_r2_sub1_nat_eip" {
#vpc = true
#    tags = {
#      Name = "user10_r2_sub1_nat_eip"
#    }
#}

#NACL
resource "aws_default_network_acl" "dev_default" {
    default_network_acl_id = aws_vpc.user10_r2_vpc.default_network_acl_id
    ingress {
        protocol = -1
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    egress {
        protocol = -1
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    subnet_ids = [ aws_subnet.user10_r2_sub1.id, aws_subnet.user10_r2_sub2.id ]
    tags = {
        Name = "dev-default"
    }
}