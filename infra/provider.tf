#Provider info for S3 plan
provider "aws" {
  region                  = "us-west-2"
  profile                 = "test-aws"
}

terraform {
  backend "s3" {
    bucket = "awscodelab-tfstate-001" 
    key    = "infra.tfstate"
    region = "us-west-2"
    profile = "test-aws"
  }
}
