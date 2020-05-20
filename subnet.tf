resource "aws_subnet" "public_1a" {
  vpc_id            = aws_vpc.dev.id
  availability_zone = "ap-southeast-1a"
  cidr_block        = "172.16.1.0/24"

  tags  = {
    Name = "public-1a"
  }
}


resource "aws_subnet" "public_1c" {
  vpc_id            = aws_vpc.dev.id
  availability_zone = "ap-southeast-1b"
  cidr_block        = "172.16.2.0/24"

  tags  = {
    Name = "public-1c"
  }
}
