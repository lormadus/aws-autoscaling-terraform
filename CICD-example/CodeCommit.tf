resource "aws_codecommit_repository" "WebAppRepo" {
  repository_name = "WebAppRepo"
  description     = "user19 App Repository"

  tags = {
    Name        = "user19-WebAppRepo"
    Creator = "user19"
  }
}
