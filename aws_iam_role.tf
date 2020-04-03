resource "aws_iam_role" "local_codebuild_role" {
  name               = "CODEBUILD-LOCAL-${upper(var.project_name)}-ROLE"
  description        = "Managed by Terraform"
  assume_role_policy = data.aws_iam_policy_document.forrole.json
}

