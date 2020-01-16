data "null_data_source" "lambda_file" {
  inputs = {
    filename = "${substr("${path.module}/functions/ami_encryption.py", length(path.cwd) + 1, -1)}"
  }
}

data "archive_file" "ami_encryption" {
  count         = var.encrypt_ami ? 1 : 0
  type        = "zip"
  source_file = "${path.module}/functions/ami_encryption.py"
  output_path = data.null_data_source.lambda_archive.outputs.filename
}

data "null_data_source" "lambda_archive" {
  inputs = {
    filename = "${path.module}/functions/ami_encryption.zip"
  }
}