#resource "aws_default_security_group" "user10_r1_sg_default" {
#    vpc_id = aws_vpc.user10_r1_vpc.id
#    ingress {
#        protocol = -1
#        self = true
#        from_port = 0
#        to_port = 0
#    }
#    egress {
#        from_port = 0
#        to_port = 0
#        protocol = "-1"
#        cidr_blocks = ["0.0.0.0/0"]
#    }
#    tags = {
#        Name = "user10_r1_sg_default"
#    }
#}

# 리전1 시큐리티 그룹
# EC2 원격접속IP 제한
resource "aws_security_group" "user10_r1_sg" {
    name = "user10_r1_sg"
    description = "open ssh port for r1_ins1"
    vpc_id = aws_vpc.user10_r1_vpc.id
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]#["15.164.219.1/32"] #
        #USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
        #ec2-user pts/0    ec2-15-164-219-1 06:55    6.00s  0.50s  0.26s sshd: ec2-user [priv]
        #여기가 원격접속 접근 IP 제어
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "user10_r1_sg"
    }
}