aws_account_id = "123456789012"
environment    = "prod"

instances = {
  brown = {
    stop_if_unused = true,
    http_allowed_ips = [
      "0.0.0.0/0"
    ]
  },
}

dns_records = {
  "example.ga" = {
    instance = "brown"
    use_eip  = false
  },
  "example.gq" = {
    instance = "brown"
    use_eip  = false
  }
}
