terraform {

  # backend "remote" {
  #   organization = "example"
  #   workspaces {
  #     name = "example-prod"
  #   }
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

}

provider "aws" {
  # profile = "shop"
  profile = "shop-test"
  # profile = "123456789012_AdministratorAccess"
  region = "eu-central-1"
}
