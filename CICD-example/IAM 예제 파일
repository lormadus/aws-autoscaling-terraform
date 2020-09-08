resource "aws_iam_role" "user19_BuildTrustRole" {
  name = "user19_BuildTrustRole"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codebuild.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    tag-key = "user19_BuildTrustRole"
  }
}

resource "aws_iam_policy" "user19_CodeBuildRolePolicy" {
  name        = "user19_CodeBuildRolePolicy"
  path        = "/"
  description = "user19_CodeBuildRolePolicy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
            {
              "Sid": "CloudWatchLogsPolicy",
              "Effect": "Allow",
              "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
              ],
              "Resource": [
                "*"
              ]
            },
            {
              "Sid": "CodeCommitPolicy",
              "Effect": "Allow",
              "Action": [
                "codecommit:GitPull"
              ],
              "Resource": [
                "*"
              ]
            },
            {
              "Sid": "S3GetObjectPolicy",
              "Effect": "Allow",
              "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
              ],
              "Resource": [
                "*"
              ]
            },
            {
              "Sid": "S3PutObjectPolicy",
              "Effect": "Allow",
              "Action": [
                "s3:PutObject"
              ],
              "Resource": [
                "*"
              ]
            },
            {
              "Sid": "OtherPolicies",
              "Effect": "Allow",
              "Action": [
                "ssm:GetParameters",
                "ecr:*"
              ],
              "Resource": [
                "*"
              ]
            }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "user19_role_policy_attach_1" {
  role       = "${aws_iam_role.user19_BuildTrustRole.name}"
  policy_arn = "${aws_iam_policy.user19_CodeBuildRolePolicy.arn}"
}

resource "aws_iam_role" "user19_DeployTrustRole" {
  name = "user19_DeployTrustRole"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
            {
              "Sid" : "",
              "Effect" : "Allow",
              "Principal" : {
                "Service": [
                    "codedeploy.amazonaws.com"
                ]
              },
              "Action" : "sts:AssumeRole"
            }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role_policy_attach_5" {
  role       = "${aws_iam_role.user19_DeployTrustRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}


resource "aws_iam_role" "user19_PipelineTrustRole" {
  name = "user19_PilelineTrustRole"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
            {
              "Sid": "1",
              "Effect": "Allow",
              "Principal": {
                "Service": [
                  "codepipeline.amazonaws.com"
                ]
              },
              "Action": "sts:AssumeRole"
            }
  ]
}
EOF
}

resource "aws_iam_policy" "user19_CodePipelinePolicy" {
  name        = "user19_CodePipelinePolicy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
            {
              "Action": [
                "s3:*"
              ],
              "Resource": ["*"],
              "Effect": "Allow"
            },
            {
            "Action": [
                "codecommit:GetBranch",
                "codecommit:GetCommit",
                "codecommit:UploadArchive",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:CancelUploadArchive"
              ],
              "Resource": "*",
              "Effect": "Allow"
            },
            {
              "Action": [
                "codepipeline:*",
                "iam:ListRoles",
                "iam:PassRole",
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision",
                "lambda:*",
                "sns:*",
                "ecs:*",
                "ecr:*"
              ],
              "Resource": "*",
              "Effect": "Allow"
            },
            {
              "Action": [
                  "codebuild:StartBuild",
                  "codebuild:StopBuild",
                  "codebuild:BatchGet*",
                  "codebuild:Get*",
                  "codebuild:List*",
                  "codecommit:GetBranch",
                  "codecommit:GetCommit",
                  "codecommit:GetRepository",
                  "codecommit:ListBranches",
                  "s3:GetBucketLocation",
                  "s3:ListAllMyBuckets"
              ],
              "Effect": "Allow",
              "Resource": "*"
          },
          {
              "Action": [
                  "logs:GetLogEvents"
              ],
              "Effect": "Allow",
              "Resource": "arn:aws:logs:*:*:log-group:/aws/codebuild/*:log-stream:*"
          }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "user19_role_policy_attach_2" {
  role       = "${aws_iam_role.user19_PipelineTrustRole.name}"
  policy_arn = "${aws_iam_policy.user19_CodePipelinePolicy.arn}"
}

resource "aws_iam_role" "user19_CodePipelineLambdaExecRole" {
  name = "user19_CodePipelineLambdaExecRole"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
            {
              "Sid": "1",
              "Effect": "Allow",
              "Principal": {
                "Service": [
                  "lambda.amazonaws.com"
                ]
              },
              "Action": "sts:AssumeRole"
            }
  ]
}
EOF
}

resource "aws_iam_policy" "user19_CodePipelineLambdaExecPolicy" {
  name        = "user19_CodePipelineLambdaExecPolicy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    	       {
      		      "Action": [
                  "logs:CreateLogGroup",
                  "logs:CreateLogStream",
                  "logs:PutLogEvents"
                  ],
      		      "Effect": "Allow",
      		      "Resource": "arn:aws:logs:*:*:*"
               },
    	       {
      		       "Action": ["codepipeline:PutJobSuccessResult",
        	                 "codepipeline:PutJobFailureResult"],
                 "Effect": "Allow",
                 "Resource": "*"
               }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "user19_role_policy_attach_3" {
  role       = "${aws_iam_role.user19_CodePipelineLambdaExecRole.name}"
  policy_arn = "${aws_iam_policy.user19_CodePipelineLambdaExecPolicy.arn}"
}

variable "prefix" {
  default = "user19"
}

resource "aws_s3_bucket" "user19_S3Bucket" {
  bucket = "${var.prefix}-cicd-workshop"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "user19_S3Bucket"
    Environment = "Dev"
  }
}

output "CodeBuildRoleArn" {
  value = "${aws_iam_role.user19_BuildTrustRole.arn}"
}
output "CodeDeployRoleArn" {
  value = "${aws_iam_role.user19_DeployTrustRole.arn}"
}
output "CodePipelineRoleArn" {
  value = "${aws_iam_role.user19_PipelineTrustRole.arn}"
}
output "LambdaRoleArn" {
  value = "${aws_iam_role.user19_CodePipelineLambdaExecRole.arn}"
}
output "S3BucketName" {
  value = "${aws_s3_bucket.user19_S3Bucket.id}"
}
