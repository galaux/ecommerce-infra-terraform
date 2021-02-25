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
  profile = "shop"
  region  = "eu-central-1"
}
