aws_account_id = "123456789012"
environment    = "test"

instances = {
  green = {
    stop_if_unused = true,
    http_allowed_ips = [
      "203.0.113.21/32", # GDB @ home
      "203.0.113.24/32"    # GAX @ home
    ]
  },
  yellow = {
    stop_if_unused = true,
    http_allowed_ips = [
      "203.0.113.21/32", # GDB @ home
      "203.0.113.24/32"    # GAX @ home
    ]
  },
}

dns_records = {
  "example.ml" = {
    instance = "green"
    use_eip  = false
  },
  "example.tk" = {
    instance = "yellow"
    use_eip  = false
  }
}
