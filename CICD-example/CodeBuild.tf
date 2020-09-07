resource "aws_codebuild_project" "devops-webapp-project" {
  name          = "user19-devops-webapp-project"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = "${aws_iam_role.user19_BuildTrustRole.arn}"

  artifacts {
    type = "S3"
    location = "user19-cicd-workshop"
    packaging = "ZIP"
    name = "WebAppOutputArtifact.zip"
  }

  environment {
    type  = "LINUX_CONTAINER"
    image = "aws/codebuild/java:openjdk-8"
    compute_type = "BUILD_GENERAL1_SMALL"
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://git-codecommit.us-west-1.amazonaws.com/v1/repos/WebAppRepo"
  }

  tags = {
    Name        = "user19_devops-webapp-project"
    Environment = "Test"
  }
}
