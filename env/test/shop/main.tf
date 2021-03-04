provider "aws" {
  profile = "shop-test"
  region  = "eu-central-1"
}

terraform {

  backend "s3" {
    bucket  = "shop-tfstate-test"
    key     = "shop.tfstate"
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
data "terraform_remote_state" "dns" {
  backend = "s3"

  config = {
    bucket  = "shop-tfstate-test"
    key     = "dns.tfstate"
    region  = "eu-central-1"
    profile = "shop-test"
  }
}
module "shop" {
  for_each = var.instances

  source = "../../../modules/shop"

  name              = each.key
  dns_zone_id       = data.terraform_remote_state.dns.outputs.dns[each.value.parent_domain].dns_zone_id
  dkim_tokens       = data.terraform_remote_state.dns.outputs.dns[each.value.parent_domain].dkim_tokens
  parent_domain     = each.value.parent_domain
  use_eip           = each.value.use_eip
  backup_bucket_arn = data.terraform_remote_state.environment.outputs.backup_bucket_arn
  key_name          = var.environment
}
