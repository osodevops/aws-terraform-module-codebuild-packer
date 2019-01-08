#this is the trust relationship
data "aws_iam_policy_document" "forrole" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "codebuild.amazonaws.com",
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}
