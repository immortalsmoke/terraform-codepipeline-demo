
resource "aws_codedeploy_app" "demo" {
  compute_platform = "Server"
  name             = "MyDemoApplication"
}


resource "aws_iam_role" "cd" {
  name = "awscode-test"
  assume_role_policy = "${file("iam/codedeploy_role.json")}" 
}

resource "aws_iam_role_policy_attachment" "cd" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = "${aws_iam_role.cd.name}"
}

resource "aws_sns_topic" "awscode" {
  name = "awscode-status"
}

resource "aws_codedeploy_deployment_group" "cd" {
  app_name              = "${aws_codedeploy_app.demo.name}"
  deployment_group_name = "awscode-test"
  service_role_arn      = "${aws_iam_role.cd.arn}"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "version"
      type  = "KEY_AND_VALUE"
      value = "0.1"
    }

    ec2_tag_filter {
      key   = "region"
      type  = "KEY_AND_VALUE"
      value = "uw2"
    }
  }

  trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "awscode-failure"
    trigger_target_arn = "${aws_sns_topic.awscode.arn}"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
