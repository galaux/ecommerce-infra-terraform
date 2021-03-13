provider "aws" {
  profile = "shop"
  region  = "eu-central-1"
}

terraform {

  backend "s3" {
    bucket  = "shop-tfstate-prod"
    key     = "instance_with_dns.tfstate"
    region  = "eu-central-1"
    profile = "shop"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

}

# Read remote state
data "terraform_remote_state" "environment" {
  backend = "s3"

  config = {
    bucket  = "shop-tfstate-prod"
    key     = "environment.tfstate"
    region  = "eu-central-1"
    profile = "shop"
  }
}

# Read remote state
data "terraform_remote_state" "zone_base" {
  backend = "s3"

  config = {
    bucket  = "shop-tfstate-prod"
    key     = "zone_base.tfstate"
    region  = "eu-central-1"
    profile = "shop"
  }
}
