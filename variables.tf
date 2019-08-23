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

variable "encrypt_ami" {
  default = true
}

variable "kms_key_arn" {
  description = "If Encrypt_ami set to true then you must pass in the arn of the key you wish to encrypt disk with."
  default = "Default"
  type = "string"
}

variable "environment_build_image" {
  type = "string"
  default = "aws/codebuild/standard:1.0"
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

variable "packer_vars_file_location" {
  type = "string"
  default = ""
  description = "The file path to where extra Packer vars can be referenced"
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
    "BUILD_INITIATOR=$CODEBUILD_INITIATOR",
    "PACKER_BUILD_VPC_ID=\"${var.vpc_id}\"",
    "PACKER_BUILD_SUBNET_ID=\"${var.packer_build_subnet_ids[0]}\"",
    "echo Validating packer tempalte to build...",
    "./packer validate -var-file=\"${var.packer_vars_file_location}\" ${var.packer_file_location}"
  ]

  ami_build_commands = [
      "./packer build -var-file=\"${var.packer_vars_file_location}\" -color=false ${var.packer_file_location} | tee build.log"
  ]

  ami_post_build_commands = [
      "egrep \"${data.aws_region.current.name}\\:\\sami\\-\" build.log | cut -d' ' -f2 > ami_id.txt",
      # Packer doesn't return non-zero status; we must do that if Packer build failed
      "test -s ami_id.txt || exit 1",
      "curl -qL -o ami_builder_event.json https://gist.githubusercontent.com/sionsmith/23b7dfcd3ab9c302dc1c172c871a589a/raw/cf96e3cde40f413afa1d3405f33d4163bdb8db0b/ami_builder_event.json",
      "sed -i.bak \"s/<<AMI-ID>>/$(cat ami_id.txt)/g\" ami_builder_event.json",
      "aws events put-events --entries file://ami_builder_event.json",
      "echo build completed on `date`"
  ]
}