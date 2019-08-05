data "aws_iam_policy_document" "lambda_config_trust" {
  count              = "${local.is_ami_encryption_enable}"
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_config_policy" {
  count              = "${local.is_ami_encryption_enable}"
  statement {
    actions   = ["ec2:Describe*", "ec2:CreateSnapshot", "ec2:CreateImage", "ec2:CreateTags*"]
    resources = ["*"]
  }

  statement {
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }

  statement {
    actions   = ["logs:*"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}
