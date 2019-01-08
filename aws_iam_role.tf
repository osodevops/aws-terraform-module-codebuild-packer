resource "aws_iam_role" "local_codebuild_role" {
  name = "Codebuild-Local-Role"

  assume_role_policy = "${data.aws_iam_policy_document.forrole.json}"
}
