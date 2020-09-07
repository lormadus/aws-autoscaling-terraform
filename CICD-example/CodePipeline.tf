resource "aws_codepipeline" "CodePipeline" {
  name     = "user19-CodePipeline"
  role_arn = "${aws_iam_role.user19_PipelineTrustRole.arn}"

  artifact_store {
    location = "${aws_s3_bucket.user19_S3Bucket.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName   = "WebAppRepo"
        BranchName = "master"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "user19-devops-webapp-project"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName = "user19-DevOps-WebApp"
        DeploymentGroupName = "user19-CodedeployDeploymentGroup-Dev"
        #AppSpecTemplatePath = "appspec.yaml"
      }
    }
  }
}
