terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_s3_bucket" "tf_state" {
  bucket        = var.bucket_tfstate
  force_destroy = true
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = var.table_tfstate
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}