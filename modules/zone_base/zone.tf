# [A delegation set][0] is a set or 4 authoritative AWS name servers. These
# names must be set in the [registrar][1] configuration. When creating a hosted
# zone, a random set is chosen by AWS which would force us to manually set them
# in the registrar config. To circumvent this, we create this delegation set
# once and for all (thus the `prevent_destroy`) and will reuse it every time.
#
# [0]: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/route-53-concepts.html#route-53-concepts-reusable-delegation-set
# [1]: https://my.freenom.com/clientarea.php?action=domaindetails
#
# As this resource has a `prevent_destroy`, it complicates the removal of other
# resources in the same directory. It should be moved to some other folder
# along with more _long term_ resources (such as the EC2 key pair, …)
#
# FIXME: 2021-03-24 AWS won't let me create a delegation that matches what we
# currently have in prod (.com and .fr) so I can't have in Terraform the
# current delegation set. I can create a new one be when I try to attach it to
# the dns_zone, Terraform says it must re-create the whole dns_zone (ie,
# destruction then creation) which I would rather avoid. I am thus disabling
# delegation set for all setups (.com, .fr, .gq, .ga, …) and I have destroyed
# the whole zone_base for .gq and .ga. The 4 delegation sets still exist, they
# are not destroyed on AWS and are also managed by TF though they are not tied
# to the dns_zones. I haven't destroyed them out of laziness, speed and just in
# case I could salvage them at some point.
resource "aws_route53_delegation_set" "main" {
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_route53_zone" "main" {
  name = var.parent_domain
  # delegation_set_id = aws_route53_delegation_set.main.id
}

