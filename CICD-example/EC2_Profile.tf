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
