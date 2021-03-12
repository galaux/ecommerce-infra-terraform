provider "aws" {
  profile = "shop"
  region  = "eu-central-1"
}

terraform {

  backend "s3" {
    bucket  = "shop-tfstate-prod"
    key     = "zone_base.tfstate"
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

module "zone_base" {
  for_each = toset(var.parent_domains)

  source = "../../../modules/zone_base"

  parent_domain = each.key
}
