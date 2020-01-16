resource "aws_iam_policy" "ami_encryption_policy" {
  count         = var.encrypt_ami ? 1 : 0
  name        = "${upper(var.environment)}-AMI-ENCRYPTION-LAMBDA-POLICY"
  path        = "/"
  description = "AMI encryption Lambda function policy to access EC2 and CloudWatch"

  policy = data.aws_iam_policy_document.lambda_config_policy[0].json
}
