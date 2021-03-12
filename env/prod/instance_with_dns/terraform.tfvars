aws_account_id = "123456789012"
environment    = "prod"

instances = {
  brown = {
    use_eip        = true,
    stop_if_unused = true,
    http_allowed_ips = [
      "203.0.113.20/32", # GDB @ home
      "203.0.113.24/32"    # GAX @ home
    ]
  },
}

dns_records = {
  "example.ga" = {
    instance = "brown"
  },
  "example.gq" = {
    instance = "brown"
  }
}
