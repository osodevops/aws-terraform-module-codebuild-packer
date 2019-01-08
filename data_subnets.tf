data "aws_subnet_ids" "subnets" {
  vpc_id = "${data.aws_vpc.codebuild.id}"

  tags {
    Name = "*Public*"
  }
}
