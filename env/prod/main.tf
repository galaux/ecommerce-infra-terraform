provider "aws" {
  profile = "shop"
  region  = "eu-central-1"
}

terraform {

  backend "s3" {
    bucket  = "shop-tfstate-prod"
    key     = "terraform.tfstate"
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

# read remote state
data "terraform_remote_state" "base" {
  backend = "s3"

  config = {
    bucket  = "shop-tfstate-prod"
    key     = "terraform.tfstate"
    region  = "eu-central-1"
    profile = "shop"
  }
}

module "base" {
  source = "../../modules/base"

  name          = var.name
  parent_domain = var.parent_domain
  public_key    = var.public_key
}

module "shop" {
  source = "../../modules/shop"

  name              = var.name
  dns_zone_id       = data.terraform_remote_state.base.outputs.dns_zone_id
  dkim_tokens       = data.terraform_remote_state.base.outputs.dkim_tokens
  parent_domain     = var.parent_domain
  backup_bucket_arn = data.terraform_remote_state.base.outputs.backup_bucket_arn
}
