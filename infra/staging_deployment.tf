locals {
  common_tags = {
    env     = terraform.workspace
    owner   = "richard chou"
    project = "aws-microservice-uploader"
  }
}

terraform {
  backend "s3" {
    bucket = "aws-microservice-uploader"
    key    = "state"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "uploader" {
  bucket = "uploader"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = local.common_tags
}