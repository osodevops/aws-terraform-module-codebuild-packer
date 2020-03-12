resource "aws_iam_role" "ami_encrypt_lambda" {
  count              = var.encrypt_ami ? 1 : 0
  name               = "${var.environment}-AMI-ENCRYPTION-LAMBDA-ROLE"
  description        = "Allows Lambda function to execute AMI copy with encrypted root volume."
  assume_role_policy = data.aws_iam_policy_document.lambda_config_trust[0].json
}

