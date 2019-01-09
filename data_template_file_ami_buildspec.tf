// Transit VPC spoke template
data "template_file" "ami_buildspec" {
  template = <<EOF
version: 0.2
phases:
  install:
    commands:
      - $${install_commands}
  pre_build:
    commands:
      - $${pre_build_commands}
  build:
    commands:
      - $${build_commands}
  post_build:
    commands:
      - $${post_build_commands}
EOF

  vars {
    install_commands    = "${join("\n      - ", local.ami_install_commands)}"
    pre_build_commands  = "${join("\n      - ", local.ami_pre_build_commands)}"
    build_commands      = "${join("\n      - ", local.ami_build_commands)}"
    post_build_commands = "${join("\n      - ", local.ami_post_build_commands)}"
  }
}
