resource "aws_lambda_permission" "cloudwatch_event" {
  statement_id  = "AllowExecutionFromCloudWatchEvent"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.ami_encryption_lambda.0.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.build_alert.arn}"
}
