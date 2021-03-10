aws_account_id = "123456789012"
environment    = "test"

instances = {
  green = {
    stop_if_unused = true
  },
  # yellow = {
  #   stop_if_unused = true
  # }
}

dns_records = {
  "example.ml" = {
    instance = "green"
    use_eip  = false
  },
  # "example.tk" = {
  #   instance = "yellow"
  #   use_eip  = false
  # }
}
