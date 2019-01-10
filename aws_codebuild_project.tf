resource "aws_codebuild_project" "builder" {
  name                  = "${var.project_name}"
  description           = "AMI builder using Packer and Ansible."
  build_timeout         = "${var.build_timeout}"
  service_role          = "${aws_iam_role.local_codebuild_role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type        = "${var.compute_type}"
    image               = "${var.environment_build_image}"
    type                = "LINUX_CONTAINER"
  }

  source {
    type                = "GITHUB"
    location            = "${var.source_repository_url}"
    buildspec           = "${data.template_file.ami_buildspec.rendered}"
    git_clone_depth     = "0"
    report_build_status = true
  }

   tags                 = ["${var.common_tags}"]

  vpc_config {
    security_group_ids = ["${aws_security_group.codebuild.id}"]
    subnets = ["${data.aws_subnet_ids.subnets.ids}"]
    vpc_id = "${data.aws_vpc.codebuild.id}"
  }
}
