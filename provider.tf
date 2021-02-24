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
  profile = "alaux"
  region  = "eu-central-1"
  assume_role {
    role_arn     = "arn:aws:iam::123456789012:role/external-user"
    session_name = "terraform"
    # external_id  = "EXTERNAL_ID"
  }
}
