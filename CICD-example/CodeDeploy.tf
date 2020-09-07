resource "aws_codedeploy_app" "CodedeployApp" {
  compute_platform = "Server"
  name             = "user19-DevOps-WebApp"
}

resource "aws_codedeploy_deployment_group" "CodedeployDeploymentGroup-Dev" {
  app_name              = "${aws_codedeploy_app.CodedeployApp.name}"
  deployment_group_name = "user19-CodedeployDeploymentGroup-Dev"
  service_role_arn      = "${aws_iam_role.user19_DeployTrustRole.arn}"
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  #deployment_config_name = "CodeDeployDefault.AllAtOnce"
  
  load_balancer_info {
    elb_info {
      name = "${aws_elb.ELB.name}"
    }
  }
  
  #ec2_tag_filter {
  #    key   = "Name"
  #    type  = "KEY_AND_VALUE"
  #    value = "user19-DevWebApp01"
  #}
  
  autoscaling_groups = ["${aws_autoscaling_group.AutoscalingGroup.name}"]
}
