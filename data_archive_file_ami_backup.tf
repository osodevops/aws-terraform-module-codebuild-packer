data "archive_file" "ami_encryption" {
  count         = "${var.encrypt_ami}"
  type        = "zip"
  source_file = "${data.null_data_source.lambda_file.outputs.filename}"
  output_path = "${data.null_data_source.lambda_archive.outputs.filename}"
}
