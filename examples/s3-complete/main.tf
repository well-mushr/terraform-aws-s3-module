provider "aws" {
  region = var.region
}

module "s3" {
  source = "../../"

  bucket = var.bucket
  region = var.region
  acl    = "private"

  versioning = true
  lifecycle = [
    {
      rule_name = "transition-rule"

      transition = {
        days          = 90
        storage_class = "STANDARD_IA"
      }
    },
    {
      rule_name = "expiration-rule"

      noncurrent_version_expiration = {
        days = 90
      }
    }
  ]

  policy = file("./bucket_policy.json")

  tags = {
    Project = var.bucket
  }
}

variable "bucket" {
  type = string
  description = "Bucket name, it should match with the name used at the test"
}

variable "region" {
  type = string
  description = "AWS region"
}