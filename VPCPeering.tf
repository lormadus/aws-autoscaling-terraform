resource "aws_vpc_peering_connection" "peer"  {
    vpc_id        = aws_vpc.user10_r1_vpc.id 
    peer_vpc_id   = "vpc-0c9562ab172aac2b5" # 피어꺼 r2먼저 돌리고 vpc 직접입력
    peer_region = "eu-west-2" #요청 받는쪽 리전2

   
    auto_accept   = false
    tags = {
        Side = "Requester"
    }
}

# VPC Peering
# 요청을 받는 쪽
# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}
