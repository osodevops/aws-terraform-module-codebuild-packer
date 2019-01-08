data "aws_iam_policy_document" "local_codebuild" {
  statement {
    resources = ["*"]

    not_actions = [
      "config:*",
      "cloudtrail:*",
      "organizations:*",
      "iam:CreateAccountAlias",
      "iam:DeleteAccountAlias",
      "iam:DeleteAccountPasswordPolicy",
      "iam:*SAMLProvider",
      "cloudformation:*StackSet*",
    ]
  }

  statement {
    actions = [
      "cloudformation:DeleteStack",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:SetStackPolicy",
      "cloudformation:UpdateStack",
      "cloudformation:CancelUpdateStack",
      "cloudformation:ContinueUpdateRollback",
      "cloudformation:CreateStack",
      "cloudformation:CreateChangeSet",
    ]

    resources = [
      "arn:aws:cloudformation:*:*:stack/StackSet-*/*",
      "arn:aws:cloudformation:*:*:stack/cloudops-cloudformation-prod-aws-stack-mana*/*",
    ]

    effect = "Deny"
    sid    = "DenyCloudOpsCFStacks"
  }

  statement {
    actions = [
      "iam:Delete*",
      "iam:Put*",
      "iam:Update*",
      "iam:PassRole",
      "iam:Detach*",
      "iam:Attach*",
    ]

    resources = [
      "arn:aws:iam::*:role/AWSCloudFormationStackSet*",
      "arn:aws:iam::*:role/WP-CloudOps-Global-Admin",
      "arn:aws:iam::*:role/WP-Trusted-Local-Admin",
    ]

    effect = "Deny"
    sid    = "DenyCloudOpsIAMRoles"
  }

  statement {
    actions = [
      "sts:AssumeRole*",
    ]

    resources = [
      "arn:aws:iam::*:role/AWSCloudFormationStackSet*",
      "arn:aws:iam::*:role/WP-CloudOps-Global-Admin",
    ]

    effect = "Deny"
    sid    = "DenyAssumeCloudOpsRoles"
  }
}
