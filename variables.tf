variable "build_timeout" { default = "60" }
variable "environment" {}
variable "vpc_cidr" {}
variable "vpc_id" {}

variable "common_tags" {
  type = "map"
}

locals {
  ami_install_commands = [
    "echo Installing Packer",
    "curl -o packer.zip https://releases.hashicorp.com/packer/0.12.3/packer_0.12.3_linux_amd64.zip && unzip packer.zip",
    "echo Validating Packer template"
  ]

  ami_pre_build_commands = [
    // Set env var OWNER_REPO, PR_ID, GIT_MASTER_COMMIT_ID,
    // GITHUB_TOKEN, GIT_ASKPASS, LATEST_COMMIT_APPLY
    ". ami-setup-env-var.sh",

    // Check CI prerequisites to do Terraform commands and set env var TF_WORKING_DIR
    ". ami-check.sh",
  ]

  ami_build_commands = [
    // Do Terraform Plan on TF_WORKING_DIR and store it on artifact folder
    ". ami-do-terraform-plan.sh",
  ]

  ami_post_build_commands = [
    // Create Plan Artifact
    ". ami-create-plan-artifact.sh",

    // Upload Plan Artifact to S3 Bucket
    ". ami-upload-plan-artifact.sh",

    // Notify Plan Artifact to Github Pull Request
    "ami-notify-plan-artifact-to-github-pr.py",
  ]
}