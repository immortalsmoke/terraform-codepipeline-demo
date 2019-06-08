
#####
# S3 Bucket and Code
#####

resource "aws_s3_bucket" "code_bucket" {
  bucket = "${var.code_bucket}"
  acl    = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "linux_code" {
  bucket = "${aws_s3_bucket.code_bucket.id}"
  key    = "${var.linux_code_key}"
  source = "${var.linux_code_source}"

  etag = "${filemd5("${var.linux_code_source}")}" #Compares file hashes to determine whether to update
}



#####
# VPC Module
#####

module "dev_vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "1.46.0"
  name               = "${var.vpc_name}"
  cidr               = "${var.vpc_cidr}"
  azs                = "${var.az_list}"
  private_subnets    = "${var.private_subnets}"
  public_subnets     = "${var.public_subnets}"
  enable_nat_gateway = true

  tags = {
  }

}






#####
# EC2 Instance-Adjacent Resources
#####

resource "aws_iam_role" "awscodelab" {
  name = "${var.iam_prefix}role"
  path = "${var.iam_role_path}"

  assume_role_policy = "${file("iam/ec2_trust_policy.json")}" 
}

resource "aws_iam_role_policy" "awscodelab" {
	name   = "${var.iam_prefix}s3access"
	role   = "${aws_iam_role.awscodelab.name}"
	policy = "${file("iam/role_policy.json")}" 
}

resource "aws_iam_instance_profile" "awscodelab" {
  name = "${var.iam_prefix}s3access"
  role = "${aws_iam_role.awscodelab.name}"
}



resource "aws_security_group" "ssh_in" {
  name        = "${var.ssh_scg_name}"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${module.dev_vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.ssh_ingress_cidr}"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


resource "tls_private_key" "awscodelab" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "awscodelab" {
  key_name   = "awscodelab-key-pair"
  public_key = "${tls_private_key.awscodelab.public_key_openssh}"
}



