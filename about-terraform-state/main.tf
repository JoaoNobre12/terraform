terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {
  
}

resource "aws_s3_bucket" "jn-state-35" {
  bucket = "jn-state-${data.aws_caller_identity.current.account_id}"
  versioning {
    enabled = false
  }

  tags = {
    Description = "stores tf state"
    ManagedBy = "Terraform"
  }
}


output "remote-state-bucket-name" {
  value = aws_s3_bucket.jn-state-35.bucket
}

output "remote-state-bucket-arn" {
  value = aws_s3_bucket.jn-state-35.arn
}