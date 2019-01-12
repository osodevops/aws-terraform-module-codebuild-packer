variable "build_timeout" { default = "60" }

variable "codebuild_private_subnet_ids" {
  type = "list"
  description = "Private subnet IDs for CodeBuild."
}

variable "compute_type" {
  type        = "string"
  default     = "BUILD_GENERAL1_SMALL"
  description = "The builder instance class"
}

variable "environment" {}

variable "environment_build_image" {
  type = "string"
  default = "aws/codebuild/ubuntu-base:14.04"
  description = "Docker image used by CodeBuild"
}

variable "packer_build_subnet_ids" {
  type        = "list"
  description = "Public subnet where Packer build instacen should run."
}

variable "packer_file_location" {
  type        = "string"
  description = "The file path of the .json packer to build."
}

variable "project_name" {
  type = "string"
  description = "Name of the CodeBuild Project"
}

variable "source_repository_url" {
  type        = "string"
  description = "The source repository URL"
}



variable "vpc_id" {}

variable "common_tags" {
  type = "map"
}

locals {
  ami_install_commands = [
   
  ]

  ami_pre_build_commands = [
    "echo Installing HashiCorp Packer...",
    "curl -qL -o packer.zip https://releases.hashicorp.com/packer/1.3.3/packer_1.3.3_linux_amd64.zip && unzip -o packer.zip",
    "echo Creat build number from git hash",
    "BUILD_NUMBER=$(git rev-parse --short HEAD)",
    "echo Validating packer tempalte to build...",
    "./packer validate ${var.packer_file_location}"
  ]

  ami_build_commands = [
      "./packer build -color=false ${var.packer_file_location} | tee build.log"
  ]

  ami_post_build_commands = [
      "egrep \"${data.aws_region.current.name}\\:\\sami\\-\" build.log | cut -d' ' -f2 > ami_id.txt",
      # Packer doesn't return non-zero status; we must do that if Packer build failed
      "test -s ami_id.txt || exit 1",
      "echo build completed on `date`"
  ]
}