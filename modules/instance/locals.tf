locals {

  # These curly braces declare a "new object", not a "block of code"!
  open_ports_ipv4 = {
    # These curly braces declare a "new object", not a "block of code"!
    for port in var.open_ports_ipv4 : port => {
      cidr_blocks = contains(["80", "443"], port) ? var.http_allowed_ips : ["0.0.0.0/0"]
    }
  }

}
