resource "aws_iam_policy" "local_codebuild" {
  name        = "CodebuildPolicy"
  description = "Managed by Terraform: Policy used in trust relationship with CodeBuild"
  path = "/service-role/"
  policy = "${data.aws_iam_policy_document.local_codebuild.json}"
}
