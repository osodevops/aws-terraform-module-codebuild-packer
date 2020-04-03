resource "aws_cloudwatch_event_rule" "build_alert" {
  # Create cloudwatch event that monitors build events and passes them to ami encryption lambda function
  count       = var.encrypt_ami ? 1 : 0
  name        = "${upper(var.project_name)}-CODEBUILD-SUCESS-ALERT"
  description = "Send alerts to encrypt AMI on build success."

  event_pattern = <<PATTERN
        {
          "source": [
            "com.ami.builder"
          ],
          "detail-type": [
            "AmiBuilder"
          ],
          "detail": {
            "AmiStatus": [
              "Created"
            ]
          }
        }
      
PATTERN

}

resource "aws_cloudwatch_event_target" "lamba_alert" {
  # Create ami encryption target
  count     = var.encrypt_ami ? 1 : 0
  rule      = aws_cloudwatch_event_rule.build_alert[0].name
  target_id = "ami-encryption-lambda"
  arn       = aws_lambda_function.ami_encryption_lambda[0].arn
}

