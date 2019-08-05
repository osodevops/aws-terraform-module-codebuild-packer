data "null_data_source" "lambda_archive" {
  count              = "${local.is_ami_encryption_enable}"
  inputs {
    filename = "${substr("${path.module}/functions/ami_encryption.zip", length(path.cwd) + 1, -1)}"
  }
}
