provider "aws" {
  profile = "shop-test"
  region  = "eu-central-1"
}

terraform {

  backend "s3" {
    bucket  = "shop-tfstate-test"
    key     = "environment.tfstate"
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

module "environment" {
  source = "../../../modules/environment"

  name               = var.name
  public_key         = var.public_key
  backup_bucket_name = "shop-backup-${var.name}"
  allowed_admin_arns = var.allowed_admin_arns
}
