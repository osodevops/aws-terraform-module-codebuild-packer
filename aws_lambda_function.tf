resource "aws_lambda_function" "ami_encryption_lambda" {
  count         = "${var.encrypt_ami}"
  filename      = "${data.archive_file.ami_encryption.0.output_path}"
  description   = "Responsible for creating AMI with encrypted root volume."
  function_name = "${var.environment}-AMI-ENCRYPTION-FUNCTION"

  role          = "${aws_iam_role.ami_encrypt_lambda.arn}"
  handler       = "ami_encryption.lambda_handler"
  runtime       = "python3.6"
  timeout       = 180
  source_code_hash = "${data.archive_file.ami_encryption.0.output_base64sha256}"



  tags = "${merge(var.common_tags,
    map("Name" , "${var.environment}-AMI-ENCRYPTION-LAMBDA")
  )}"
}