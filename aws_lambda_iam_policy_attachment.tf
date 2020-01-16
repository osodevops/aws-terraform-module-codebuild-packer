resource "aws_iam_policy_attachment" "ami_encryption_policy" {
  count         = var.encrypt_ami ? 1 : 0
  name       = "ami-encryption-attachment"
  roles      = [aws_iam_role.ami_encrypt_lambda[0].name]
  policy_arn = aws_iam_policy.ami_encryption_policy[0].arn
}
