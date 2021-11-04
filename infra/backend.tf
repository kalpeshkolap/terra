terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
#storing state file to remote location(aws_s3 backend)
terraform {
  backend "s3" {
    bucket = "********************"
    key    = "***************"
    region = "us-west-2"
  }
}
