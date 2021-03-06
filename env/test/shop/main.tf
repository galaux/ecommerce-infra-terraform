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

data "aws_instance" "instances" {
  for_each = var.instances

  instance_tags = {
    Name = each.key
  }
}

module "shop" {
  for_each = toset(var.instances)

  source = "../../../modules/shop"

  name              = each.key
  backup_bucket_arn = data.terraform_remote_state.environment.outputs.backup_bucket_arn
  key_name          = var.environment
}

module "dns_records" {
  for_each = var.dns_records

  source = "../../../modules/dns_records"

  dns = data.terraform_remote_state.dns.outputs.dns[each.key]

  use_eip  = each.value.use_eip
  instance = data.aws_instance.instances[each.value.instance]
}
