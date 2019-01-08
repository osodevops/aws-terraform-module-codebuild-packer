resource "aws_iam_policy" "local_codebuild" {
  name        = "CodebuildPolicy"
  description = "Policy used in trust relationship with CodeBuild"

  policy = "${data.aws_iam_policy_document.local_codebuild.json}"
}
