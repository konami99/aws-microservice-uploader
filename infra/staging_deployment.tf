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
  bucket = "uploader-konami99"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = local.common_tags
}

resource "aws_sns_topic" "s3-event-notification" {
  name = "s3-event-notification-topic"

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:s3-event-notification-topic",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.uploader.arn}"}
        }
    }]
}
POLICY
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.uploader.id

  topic {
    topic_arn = aws_sns_topic.s3-event-notification.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

resource "aws_ssm_parameter" "sns-arn" {
  name  = "sns_arn"
  type  = "SecureString"
  value = aws_sns_topic.s3-event-notification.arn

  tags = local.common_tags
}