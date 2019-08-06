data "aws_iam_policy_document" "lambda_config_trust" {
  count         = "${var.encrypt_ami}"
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
  count         = "${var.encrypt_ami}"
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
