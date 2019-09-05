resource "aws_iam_role_policy_attachment" "local_codebuild" {
  role       = "${aws_iam_role.local_codebuild_role.name}"
  policy_arn = "${aws_iam_policy.local_codebuild.arn}"
}
