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

data "aws_instance" "instances" {
  for_each = var.instances

  instance_tags = {
    Name = each.key
  }
}

module "instance" {
  for_each = var.instances

  source = "../../../modules/instance"

  name              = each.key
  backup_bucket_arn = data.terraform_remote_state.environment.outputs.backup_bucket_arn
  key_name          = var.environment
  aws_account_id    = var.aws_account_id
  stop_if_unused    = each.value.stop_if_unused
}

module "dns_records" {
  for_each = var.dns_records

  source = "../../../modules/dns_records"

  zone_base = data.terraform_remote_state.zone_base.outputs.zone_base[each.key]

  use_eip  = each.value.use_eip
  instance = data.aws_instance.instances[each.value.instance]
}
