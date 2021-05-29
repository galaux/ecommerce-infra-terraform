module "instances" {
  for_each = {
    brown = {
      stop_if_unused = false
    }
  }

  source = "../../../modules/instance"

  name              = each.key
  backup_bucket_arn = data.terraform_remote_state.environment.outputs.backup_bucket_arn
  key_name          = var.environment
  aws_account_id    = var.aws_account_id
  stop_if_unused    = each.value.stop_if_unused
  http_allowed_ips  = var.http_allowed_ips
}

# terraform import aws_eip.main_prod 203.0.113.10
resource "aws_eip" "main_prod" {
  instance = module.instances["brown"].id
  vpc      = true
}

module "dns_records_sets" {
  for_each = {
    "example.com" = {
      target = aws_eip.main_prod
    }
    "example.fr" = {
      target = aws_eip.main_prod
    }
    "example.gq" = {
      # target = aws_eip.main_prod
      target = module.instances["brown"]
    }
    "example.ga" = {
      # target = aws_eip.main_prod
      target = module.instances["brown"]
    }
  }

  source = "../../../modules/dns_records"

  zone_base = data.terraform_remote_state.zone_base.outputs.zone_base[each.key]
  target_ip = each.value.target.public_ip
}
