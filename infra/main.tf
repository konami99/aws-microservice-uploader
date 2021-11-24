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
  }
}

provider "aws" {
  region = "us-west-2"
}