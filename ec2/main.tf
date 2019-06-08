#####
# EC2 Instances
#####

data "terraform_remote_state" "infra" {
  backend = "s3"
  config {
		key    = "infra.tfstate"
    bucket = "awscodelab-tfstate-001"
		region = "us-west-2"
  }
}

data "aws_ami" "amzn" {
  most_recent = "true"

  filter {
    name = "name"
    values = ["amzn-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}



resource "aws_instance" "linux_test" {
  ami           = "${data.aws_ami.amzn.id}"
  instance_type = "t3.micro"
  associate_public_ip_address = true
  user_data     = "${file("userdata/linux.sh")}"
  count         = 2
  iam_instance_profile = "${data.terraform_remote_state.infra.iam_instance_profile}"
  subnet_id     = "${data.terraform_remote_state.infra.subnet_id}"
  vpc_security_group_ids = ["${data.terraform_remote_state.infra.sec_group}"]
  key_name     = "${data.terraform_remote_state.infra.key_name}"


  tags {
    Name = "${format("%s%03d", "${data.terraform_remote_state.infra.ec2_ins_prefix}", count.index + 1)}"
    env  = "${data.terraform_remote_state.infra.env}"
  }
}

