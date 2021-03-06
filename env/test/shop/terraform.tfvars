environment = "test"

instances = [
  "green",
  "yellow"
]

dns_records = {
  "example.ml" = {
    instance = "green"
    use_eip  = true
  },
  "example.tk" = {
    instance = "yellow"
    use_eip  = true
  }
}
