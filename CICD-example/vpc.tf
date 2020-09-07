resource "aws_vpc" "VPC" {
  cidr_block  = "19.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "user19-DevOpsVPC"
  }
}

resource "aws_default_route_table" "DefaultRouteTable" {
  default_route_table_id = "${aws_vpc.VPC.default_route_table_id}"

  tags = {
    Name = "user19-DefaultRouteTable"
  }
}

data "aws_availability_zones" "available" {
}

resource "aws_subnet" "publicSubnet01" {
  vpc_id = "${aws_vpc.VPC.id}"
  cidr_block = "19.0.1.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "user19-publicSubnet01"
  }
}

resource "aws_subnet" "publicSubnet02" {
  vpc_id = "${aws_vpc.VPC.id}"
  cidr_block = "19.0.2.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "user19-publicSubnet02"
  }
}

resource "aws_internet_gateway" "InternetGateway" {
  vpc_id = "${aws_vpc.VPC.id}"
  tags = {
    Name = "user19-InternetGateway"
  }
}

resource "aws_route" "PublicRoute" {
  route_table_id = "${aws_vpc.VPC.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.InternetGateway.id}"
}

resource "aws_route_table_association" "publicSubnet01_association" {
  subnet_id = "${aws_subnet.publicSubnet01.id}"
  route_table_id = "${aws_vpc.VPC.main_route_table_id}"
}

resource "aws_route_table_association" "publicSubnet02_association" {
  subnet_id = "${aws_subnet.publicSubnet02.id}"
  route_table_id = "${aws_vpc.VPC.main_route_table_id}"
}

resource "aws_default_network_acl" "DefaultNetworkAcl" {
  default_network_acl_id = "${aws_vpc.VPC.default_network_acl_id}"

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "user19-DefaultNetworkAcl"
  }
}

resource "aws_network_acl" "PublicNetworkAcl" {
  vpc_id = "${aws_vpc.VPC.id}"
  subnet_ids = [
    "${aws_subnet.publicSubnet01.id}",
    "${aws_subnet.publicSubnet02.id}"
  ]

  tags = {
    Name = "user19-PublicNetworkAcl"
  }
}

#resource "aws_network_acl_rule" "PublicIngress80" {
#  network_acl_id = "${aws_network_acl.PublicNetworkAcl.id}"
#  rule_number = 100
#  rule_action = "allow"
#  egress = false
#  protocol = "tcp"
#  cidr_block = "0.0.0.0/0"
#  from_port = 80
#  to_port = 80
#}

#resource "aws_network_acl_rule" "PublicEgress80" {
#  network_acl_id = "${aws_network_acl.PublicNetworkAcl.id}"
#  rule_number = 100
#  rule_action = "allow"
#  egress = true
#  protocol = "tcp"
#  cidr_block = "0.0.0.0/0"
#  from_port = 80
#  to_port = 80
#}

#resource "aws_network_acl_rule" "PublicIngress22" {
#  network_acl_id = "${aws_network_acl.PublicNetworkAcl.id}"
#  rule_number = 120
#  rule_action = "allow"
#  egress = false
#  protocol = "tcp"
#  cidr_block = "0.0.0.0/0"
#  from_port = 22
#  to_port = 22
#}

#resource "aws_network_acl_rule" "PublicEgress22" {
#  network_acl_id = "${aws_network_acl.PublicNetworkAcl.id}"
#  rule_number = 120
#  rule_action = "allow"
#  egress = true
#  protocol = "tcp"
#  cidr_block = "${aws_vpc.VPC.cidr_block}"
#  from_port = 22
#  to_port = 22
#}

#resource "aws_network_acl_rule" "PublicIngress443" {
#  network_acl_id = "${aws_network_acl.PublicNetworkAcl.id}"
#  rule_number = 130
#  rule_action = "allow"
#  egress = false
#  protocol = "tcp"
#  cidr_block = "0.0.0.0/0"
#  from_port = 443
#  to_port = 443
#}

#resource "aws_network_acl_rule" "PublicEgress443" {
#  network_acl_id = "${aws_network_acl.PublicNetworkAcl.id}"
#  rule_number = 130
#  rule_action = "allow"
#  egress = true
#  protocol = "tcp"
#  cidr_block = "0.0.0.0/0"
#  from_port = 443
#  to_port = 443
#}

resource "aws_network_acl_rule" "PublicIngressEphemeral" {
  network_acl_id = "${aws_network_acl.PublicNetworkAcl.id}"
  rule_number = 140
  rule_action = "allow"
  egress = false
  protocol = "-1"
  cidr_block = "0.0.0.0/0"
  from_port = 0
  to_port = 65535
}

resource "aws_network_acl_rule" "PublicEgressEphemeral" {
  network_acl_id = "${aws_network_acl.PublicNetworkAcl.id}"
  rule_number = 140
  rule_action = "allow"
  egress = true
  protocol = "-1"
  cidr_block = "0.0.0.0/0"
  from_port = 0
  to_port = 65535
}

resource "aws_default_security_group" "DefaultSecurityGroup" {
  vpc_id = "${aws_vpc.VPC.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "user19-DefaultSecurityGroup"
  }
}

resource "aws_security_group" "SecurityGroup" {
  name = "user19-SecurityGroup"
  description = "Security group for user19 instance"
  vpc_id = "${aws_vpc.VPC.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 123
    to_port = 123
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9418
    to_port = 9418
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "user19-SecurityGroup"
  }
}

resource "aws_iam_role" "WebAppRole" {
  name = "user19_WebAppRole"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
            {
              "Sid": "",
              "Effect": "Allow",
              "Principal": {
                "Service": "ec2.amazonaws.com"
              },
              "Action": "sts:AssumeRole"
            }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role_policy_attach_6" {
  role       = "${aws_iam_role.WebAppRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployReadOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "role_policy_attach_7" {
  role       = "${aws_iam_role.WebAppRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}


resource "aws_iam_policy" "WebAppRolePolicies" {
  name        = "user19_WebAppRolePolicies"
  path        = "/"
  description = "user19_WebAppRolePolicies"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
            {
              "Effect": "Allow",
              "Action": [
                "autoscaling:Describe*",
                "autoscaling:EnterStandby",
                "autoscaling:ExitStandby",
                "autoscaling:UpdateAutoScalingGroup"
              ],
              "Resource" : "*"
            },
            {
              "Effect": "Allow",
              "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus"
              ],
              "Resource": "*"
            },
            {
              "Effect": "Allow",
              "Action": [
                "s3:Get*",
                "s3:List*"
              ],
              "Resource": [
                "arn:aws:s3:::user19-cicd-workshop",
                "arn:aws:s3:::user19-cicd-workshop/*",
                "arn:aws:s3:::user19-CodePipeline*"
              ]
            }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "user19_role_policy_attach_4" {
  role       = "${aws_iam_role.WebAppRole.name}"
  policy_arn = "${aws_iam_policy.WebAppRolePolicies.arn}"
}

resource "aws_iam_instance_profile" "InstanceProfile" {
  name = "user19_InstanceProfile"
  role = "${aws_iam_role.WebAppRole.name}"
}

resource "aws_key_pair" "EC2_sshkey_pub" {
  key_name   = "user19_sshkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxtdP1XbbY+Gd2YcvcTZonjQc8RFRGJISKVAvV+fSoUKchRBxf+6LOB0BOqV6YnvDtbULvAaMUBeRLEm4lp4Cior5jqGEYawTO2bCAtK/JSEvZmA6dNOJznsVqv0jmTwqiYCXPXtcDYpSXgyn0aj051idrFTk+wJn+C/S8JfvATQNaNX8EW5XcNHWs+w7TEuut++398MDCTNo8FzrRMUSbWstEzFAwvVtvAVpAI48D30DKuulwiajpkLdR+WXyjlWHKQduMyXvW/IIeq9xGvT/3dEwcPTx/ENgaWzcZF+7cYjDjHa+P5zbTgKcoXcJmBtjYjk5eAsVfvw5Ce3dvdZj ec2-user@ip-172-31-12-236"
}

variable default_keypair_name {
  default = "user19_sshkey"
}

#resource "aws_instance" "DevWebApp01" {
#  ami = "ami-0ec0b3eb271f5afbc"
#  availability_zone = "${aws_subnet.publicSubnet01.availability_zone}"
#  instance_type = "t2.micro"
#  iam_instance_profile = "${aws_iam_instance_profile.InstanceProfile.id}" 
#  key_name = var.default_keypair_name
#  vpc_security_group_ids = [
#    "${aws_default_security_group.DefaultSecurityGroup.id}",
#    "${aws_security_group.SecurityGroup.id}"
#  ]
#  subnet_id = "${aws_subnet.publicSubnet01.id}"
#  associate_public_ip_address = true

#  user_data = <<-EOF
##!/bin/bash
#yum upgrade
#yum install -y aws-cli
#yum install -y git
##yum install -y ruby
#cd /home/ec2-user/
#wget https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/codedeploy-agent.noarch.rpm
#yum -y install codedeploy-agent.noarch.rpm
#service codedeploy-agent start
#EOF

#  tags = {
#    Name = "user19-DevWebApp01"
#  }
#}