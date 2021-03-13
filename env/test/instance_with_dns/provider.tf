provider "aws" {
  profile = "shop-test"
  region  = "eu-central-1"
}

terraform {

  backend "s3" {
    bucket  = "shop-tfstate-test"
    key     = "instance_with_dns.tfstate"
    region  = "eu-central-1"
    profile = "shop-test"
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
    bucket  = "shop-tfstate-test"
    key     = "environment.tfstate"
    region  = "eu-central-1"
    profile = "shop-test"
  }
}

# Read remote state
data "terraform_remote_state" "zone_base" {
  backend = "s3"

  config = {
    bucket  = "shop-tfstate-test"
    key     = "zone_base.tfstate"
    region  = "eu-central-1"
    profile = "shop-test"
  }
}
