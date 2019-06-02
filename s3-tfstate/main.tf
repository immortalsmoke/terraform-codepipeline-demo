# S3 buckets for state files (Terraform, Kubernetes, etc)
# These are separated out from other s3 plans since these should be created once and never touched again.

locals {
	tfstate_bucket_name = "awscodelab-tfstate-001"
}

resource "aws_s3_bucket" "awscodelab-tfstate-001" {
	bucket = "${local.tfstate_bucket_name}"
  acl    = "private"
  region = "us-west-2"
  versioning {
    enabled = true
  }

  tags = {
	  Name = "${local.tfstate_bucket_name}"
    Environment = "dev"
  }
}

