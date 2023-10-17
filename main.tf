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

module "core" {
  source = "./module"
  az_count = var.az_count
  subnet_cidr_bits = var.subnet_cidr_bits
  vpc_cidr_main = var.vpc_cidr_main
  project = var.project
}
