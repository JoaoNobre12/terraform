terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    # if this field is blank, the cli asks for the values
    bucket = "jn-state-200507340845"
    key    = "dev/tfstate/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {

}

resource "aws_s3_bucket" "jn-state-35" {
  bucket = "jn-state-${data.aws_caller_identity.current.account_id}"

  tags = {
    Description = "stores tf state"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "myversioning" {
  bucket = aws_s3_bucket.jn-state-35.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "remote-state-bucket-name" {
  value = aws_s3_bucket.jn-state-35.bucket
}

output "remote-state-bucket-arn" {
  value = aws_s3_bucket.jn-state-35.arn
}