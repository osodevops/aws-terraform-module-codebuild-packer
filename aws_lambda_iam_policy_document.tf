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
    effect = "Allow"
    actions   = ["ec2:Describe*", "ec2:CreateSnapshot", "ec2:CreateImage", "ec2:CreateTags*", "ec2:CopyImage"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions   = ["logs:*"]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    effect = "Allow"
    actions = ["kms:*"]
    resources = ["*"]
  }
}
