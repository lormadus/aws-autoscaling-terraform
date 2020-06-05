# VPC Peering
# 리전1의 VPC에만 코드 작성
# 요청을 보내는 쪽
# Requester's side of the connection.
#data "aws_caller_identity" "peer" {
#  provider = "aws.peer"
#} 요청받는쪽계정을 같은 폴더에서 돌릴때..
provider "aws" {
  region = "us-east-2"

  # Requester's credentials.
}
provider "aws" {
    ## 연결할 리전정보와 peer를 추가
    alias  = "peer"
    region = "eu-west-2"
    ## user10용 AWS - IAM - 사용자 - user10 - 보안자격증명 - Access key 만들기해서 미사용
    ##shared_credentials_file = "~/.aws/credentials“
}
data "aws_caller_identity" "peer" {
  provider = "aws.peer"
}

resource "aws_vpc_peering_connection" "peer"  {
    vpc_id        = aws_vpc.user10_r1_vpc.id #본인거
    peer_vpc_id   = "vpc-0c9562ab172aac2b5" # 피어꺼 r2먼저 돌리고 vpc 직접입력
    peer_owner_id = data.aws_caller_identity.peer.account_id # 콘솔로그인시 계정으로 상대계정. 
    peer_region = "eu-west-2" #요청 받는쪽 리전2
    #두번째 리전 인스턴스 실행 후 AWS에서 확인한 걸 수동으로 넣기
    #그리고 나서 에러나면 r2에 ocx값으로 라우팅테이블 설정 적용하고 실행 후 다시 실행해보기
   
    auto_accept   = false
    tags = {
        Side = "Requester"
    }
}

# VPC Peering
# 요청을 받는 쪽
# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = "aws.peer"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}