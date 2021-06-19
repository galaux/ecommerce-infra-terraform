locals {

  # This part declares a variable such as:
  # open_ports_ipv4 = {
  #   "30000-30100": {  # this _label_ is not used
  #     from: "30000",
  #     to "30100": ,
  #     cidr_blocks: ["0.0.0.0/0"] # potentially changed if sensible port
  #   }
  # }
  # FIXME we only check if port is sensible based on the `from` but we should
  # also check the `to` or even better that from→to doesn't encompasses a
  # sensible port.

  # These curly braces declare a "new object", not a "block of code"!
  open_ports_ipv4 = {
    # These curly braces declare a "new object", not a "block of code"!
    for ports in var.open_ports_ipv4 : "${ports.from}-${ports.to}" => {
      from : ports.from,
      to : ports.to,
      cidr_blocks = contains(["80", "443"], ports.from) ? var.http_allowed_ips : ["0.0.0.0/0"]
    }
  }

}
