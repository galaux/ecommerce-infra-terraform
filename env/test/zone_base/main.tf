provider "aws" {
  profile = "shop-test"
  region  = "eu-central-1"
}

terraform {

  backend "s3" {
    bucket  = "shop-tfstate-test"
    key     = "zone_base.tfstate"
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

module "zone_base" {
  for_each = toset(var.parent_domains)

  source = "../../../modules/zone_base"

  parent_domain = each.key
}
