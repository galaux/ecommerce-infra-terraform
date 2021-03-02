provider "aws" {
  # profile = "shop"
  profile = "shop-test"
  # profile = "123456789012_AdministratorAccess"
  region = "eu-central-1"
}

terraform {

  # backend "remote" {
  #   organization = "example"
  #   workspaces {
  #     name = "example-prod"
  #   }
  # }

  backend "s3" {
    bucket  = "shop-tfstate-test"
    key     = "tk/terraform.tfstate"
    region  = "eu-central-1"
    profile = "shop-test"
    # dynamodb_table = "terraform"
    # encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

}

module "shop" {
  source = "../../../modules/shop"

  name = var.name

  # cidr = "${var.cidr}"
  # azs = "${var.azs}"
  # public_subnets = "${var.public_subnets}"
}

