data "null_data_source" "lambda_file" {
  count         = "${var.encrypt_ami}"
  inputs {
    filename = "${substr("${path.module}/functions/ami_encryption.py", length(path.cwd) + 1, -1)}"
  }
}
