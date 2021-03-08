environment = "test"

instances = [
  "green",
  # "yellow"
]

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
