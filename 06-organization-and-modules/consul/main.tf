terraform {
  # Assumes s3 bucket and dynamo DB table already set up
  # See /code/03-basics/aws-backend
  backend "s3" {
    bucket         = "florin-tf-state"
    key            = "06-organization-and-modules/consul/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


############################################################
##
## NOTE: if you are deploying this in your production setup
## follow the instructions in the github repo on how to modify
## deploying with the defaults here as an example of the power
## of modules.
##
## REPO: https://github.com/hashicorp/terraform-aws-consul
##
############################################################
module "consul" {
  source         = "../web-app-module"
  bucket_prefix  = "consul-bucket"
  domain         = "consul.devopsdeployed.com"
  app_name       = "consul-app"
  environment_name = "dev"
  instance_type  = "t2.micro"
  create_dns_zone = true
  db_name        = "consuldb"
  db_user        = "foo"
  db_pass        = "bar123!"
}
