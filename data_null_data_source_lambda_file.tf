data "null_data_source" "lambda_file" {
  count              = "${local.is_ami_encryption_enable}"
  inputs {
    filename = "${substr("${path.module}/functions/ami_encryption.py", length(path.cwd) + 1, -1)}"
  }
}
