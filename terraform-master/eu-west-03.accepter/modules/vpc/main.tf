# Region의 availability zones 정보 확보 
data "aws_availability_zones" "available" {
  state    = "available"
}

locals {
  # Region의 availability zones 수
  zone_count = length(data.aws_availability_zones.available.names)
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.VPC_CIDR
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "${var.WHO_ARE_YOU}-vpc"
  }
}

# frontend subnets
resource "aws_subnet" "frontend" {
  count                   = var.FRONTEND_SUBNET_COUNT

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index+1)
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[(count.index%local.zone_count)]

  tags = {
    Name = "${var.WHO_ARE_YOU}-frontend-subnet"
  }
}


# Internet GW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.WHO_ARE_YOU}-igw"
  }
}

# route tables for frontend
resource "aws_route_table" "frontend" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  #VPC-peering 시 추가
  route {
     cidr_block = var.PEER_CIDR
     gateway_id = var.PEER_ID
  }

  tags = {
    Name = "${var.WHO_ARE_YOU}-frontend-route"
  }
}

# route associations frontend
resource "aws_route_table_association" "frontend-association" {
  count          = length(aws_subnet.frontend)
  subnet_id      = aws_subnet.frontend[count.index].id
  route_table_id = aws_route_table.frontend.id
}


###############################################################################
# BACKEND SUBNET 구성
###############################################################################
resource "aws_subnet" "backend" {
  
  count = var.ENABLE_BACKEND_SUBNET ? var.BACKEND_SUBNET_COUNT : 0 

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index+var.FRONTEND_SUBNET_COUNT+1)
  map_public_ip_on_launch = "false"
  availability_zone       = data.aws_availability_zones.available.names[(count.index%local.zone_count)]

  tags = {
    Name = "${var.WHO_ARE_YOU}-backend-subnet"
  }
}

# NAT를 위한 eip
resource "aws_eip" "nat_ip" {
  vpc = true
  tags = {
    Name = "${var.WHO_ARE_YOU}-eip-for-nat"
  }
  count = var.ENABLE_BACKEND_SUBNET ? 1 : 0 
}

# NAT는 
# 1. Public Subnet에 위치(독자 Pirvate IP도 가짐)
# 2. EIP를 할당 받고
# 3. 인터넷 연결을 위해선는 Public Subnet의 Instance와 동일하게 I-GW연결
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_ip[0].id
  subnet_id     = aws_subnet.frontend[count.index].id
  depends_on    = [aws_internet_gateway.igw] 

  count = var.ENABLE_BACKEND_SUBNET ? 1 : 0 

  tags = {
    Name = "${var.WHO_ARE_YOU}-nat-gw"
  }
}

# VPC setup for NAT
resource "aws_route_table" "backend_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[0].id
  }

  tags = {
    Name = "${var.WHO_ARE_YOU}-backend_route"
  }
  count = var.ENABLE_BACKEND_SUBNET ? 1 : 0
}

# route associations backend subnet
resource "aws_route_table_association" "backend-association" {
  count          = var.BACKEND_SUBNET_COUNT
  subnet_id      = aws_subnet.backend[count.index].id
  route_table_id = aws_route_table.backend_route[0].id
}
