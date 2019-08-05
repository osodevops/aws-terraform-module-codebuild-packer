resource "aws_iam_policy_attachment" "ami_encryption_policy" {
  count              = "${local.is_ami_encryption_enable}"
  name       = "ami-encryption-attachment"
  roles      = ["${aws_iam_role.ami_encrypt_lambda.name}"]
  policy_arn = "${aws_iam_policy.ami_encryption_policy.arn}"
}
