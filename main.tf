terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  #had to disable saving remote tf state file demo for localstack, as it seems the force path style has been removed from higher version of terraform
  #nonetheless this should work when using aws instead of localstack
  #backend "s3" {
  #  bucket         = "demoremotetfstate"
  #  key            = "demoremotetfstate.tfstate"
  #  dynamodb_table = "demoremotetfstate"
  #  region         = "us-east-1"
  #  encrypt        = true
  #}

}