terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_s3_bucket" "demoRemoteTFState" {
  bucket        = var.tf_bucket_name
  force_destroy = true
}
resource "aws_s3_bucket_acl" "demoRemoteTFstate" {
    bucket = aws_s3_bucket.demoRemoteTFState.id
    acl = "private"
}

resource "aws_s3_bucket_versioning" "demoRemoteTFState" {
    bucket = aws_s3_bucket.demoRemoteTFState.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_dynamodb_table" "demoRemoteTFState" {
  name     = var.tf_table_name
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}

