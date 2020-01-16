data "null_data_source" "lambda_file" {
  count         = var.encrypt_ami ? 1 : 0
  inputs = {
    filename = "${substr("${path.module}/functions/ami_encryption.py", length(path.cwd) + 1, -1)}"
  }
}

data "null_data_source" "lambda_archive" {
  count         = var.encrypt_ami ? 1 : 0
  inputs = {
    filename = "${path.module}/functions/ami_encryption.zip"
  }
}

data "archive_file" "ami_encryption" {
  count         = var.encrypt_ami ? 1 : 0
  type        = "zip"
  source_file = data.null_data_source.lambda_file[0].outputs.filename
  output_path = data.null_data_source.lambda_archive[0].outputs.filename
}