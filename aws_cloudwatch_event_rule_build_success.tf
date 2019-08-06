resource "aws_cloudwatch_event_rule" "build_alert" {
  # Create cloudwatch event that monitors build events and passes them to ami encryption lambda function
  name = "code-build-alerts"
  description = "Send alerts to siren-call on build events"

  event_pattern = <<PATTERN
      {
        "source": [
          "aws.codebuild"
        ],
        "detail-type": [
          "CodeBuild Build State Change"
        ],
        "detail": {
          "build-status": [
            "SUCCEEDED"
          ],
          "project-name": [
            "${aws_codebuild_project.builder.name}"
          ]
        }
      }
      PATTERN
}

resource "aws_cloudwatch_event_target" "lamba_alert" {
  # Create ami encryption target
  rule      = "${aws_cloudwatch_event_rule.build_alert.name}"
  target_id = "ami-encryption-lambda"
  arn       = "${aws_lambda_function.ami_encryption_lambda.arn}"
}