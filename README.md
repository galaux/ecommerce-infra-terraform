# example Terraform

## Setup AWS switch role:

- [Test](https://signin.aws.amazon.com/switchrole?roleName=admin&account=123456789012&displayName=shop-test)
- [Prod](https://signin.aws.amazon.com/switchrole?roleName=admin&account=123456789012&displayName=shop-prod)

## Notes on using different AWS accounts for `test` and `prod`

I've managed to set it up but this complexifies the handling of DNS entries
because `test` and `prod` use the same domain name name. This means I would
have to have some global entry redirecting to each account depending on the
route: if `test.example.com`, then send to `test` accound Route53, but
if `example.com` then send it to the `prod` account.

I'm thus going to forget about having two separate account for now. Still, here
is how I managed to do this:

Following [this
article](https://dev.to/saluminati/aws-using-multiple-staging-uat-and-production-accounts-under-aws-organization-2jng)
(watch-out: the _user_ and _group_ mentioned in this article seem to be _SSO
user_ and _SSO groups_ not to be confused with plain _IAM user_ and _IAM
groups_. At least that's what I assume because when I create them as specified
on the article, they don't appear on the AWS/IAM tab. I assume the SSO part
must be considered as a supplementary layer on top of the regular IAM
users/groups), I've created an AWS organization for shop, created
`shop-test` and `shop-prod` accounts, enabled SSO, created a user
galaux (on shop), created groups `test` and `prod` and added user galaux
to these. Finally, I've granted an admin policy to accounts `shop-test`
and `shop-prod`.

I then logged in to [the SSO console that I've
setup](https://shop.awsapps.com/start#/) with the login/password setup
for user `galaux`. One can also log-in using the emails I specified when I
created the accounts ang go to console.aws.amazon.com as these accounts are
root accounts (just use the "forgotten password") Upon login, I am asked wich
account I want to log in. I choose `shop-test` and am now seing the AWS
console for this account.

I've stopped here but I guess the only remaining steps to be able to use it on
CLI (and thus Terraform) would be to use this web console UI to create a role
that would thus belong to account `shop-test` that give admin privileges
on _everything_ (ie _everything on this account only_) and run Terraform with
this role.

Watch-out: each "account" created must be associated with a credit card number
and a phone number before it can be deleted.

Last note: I'm not sure I even need to have SSO setup. I can create sub-privs
accounts for `shop-test` and `shop-prod` as well as external admin
role that I give to my guillaume@alaux account.


## Note on running Ansible from Terraform

As explained in [this
article](https://www.terraform.io/docs/language/resources/provisioners/syntax.html#provisioners-are-a-last-resort),
_"provisioners are a last resort_. As far as I understand from skimming through
the article, Terraform pushes generating throwable images to be deployed then
destroyed rather than mixing Terraform with a provisioner. Our use case is
different from a big company's that can afford this. It would maybe be better
if we didn't try to run Ansible from Terraform but rather consider the 2 as
tools for different level needs.


## Note on starting/stopping an instance from Terraform or a UI

It seems one can start/stop an EC2 instance using the `local-exec` provider:

```
resource "null_resource" "osef" {
  provisioner "local-exec" {
    command = "echo ${aws_instance.main.private_ip} >> private_ips.txt"
  }
}
```

We could use this to run a couple of `aws` commands to get the instance ID and
state and start or stop it but there would be no way to trigger it from a UI
such as I was hoping GDB could use.

2021-03-02: Let's keep it simple for now and go for this solution:
- Terraform's usefuleness lies in saving the required AWS state on config files
- Ansible's usefuleness lies in saving the required instance state on config
  files
- if we need to spin a new instance (test or prod), update or check an already
  created one (its certificates for instance), I can do this by manually
  running Terraform and then manually running Ansible targeting the new
  instance
- if GDB wants to stop/start a test instance, he can do so as usual by logging
  on the AWS console
- no need to setup some fancy way to run Ansible from Terraform
- we _could_ use `local-exec` to check and start the EC2 instance though this
  wouldn't really be necessary
- setting up a remote backend could be nice (remotely saves the state to
  prevent errasing it locally) though not necessary (we said we wouldn't be
  running Terraform from anywhere else)


## TODO

- handle Letsencrypt certificate in Terraform through this
  https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/certificate
- split the current `shop` module into multiple ones:
  - dns_zone
  - …

### In prod

#### To import

- `data.terraform_remote_state.base`
- `module.base.aws_s3_bucket.backup`
- `module.base.aws_ses_domain_dkim.main`
- `module.base.aws_ses_domain_identity.main`
- `module.shop.aws_iam_access_key.ses_smtp`
- `module.shop.aws_iam_instance_profile.ec2_profile`
- `module.shop.aws_iam_policy.s3_bucket_access`
- `module.shop.aws_iam_policy_attachment.attach_s3_policy_ec2`
- `module.shop.aws_iam_role.ec2_assume`
- `module.shop.aws_iam_user.ses_smtp`
- `module.shop.aws_iam_user_policy.ses_smtp`
- `module.shop.aws_instance.main`
- `module.shop.aws_route53_record.dkim[0]`
- `module.shop.aws_route53_record.dkim[1]`
- `module.shop.aws_route53_record.dkim[2]`
- `module.shop.aws_route53_record.dmarc`
- `module.shop.aws_route53_record.mx`
- `module.shop.aws_route53_record.parent_domain`
- `module.shop.aws_route53_record.spf`
- `module.shop.aws_route53_record.sub_domain["admin"]`
- `module.shop.aws_route53_record.sub_domain["blog"]`
- `module.shop.aws_route53_record.sub_domain["www"]`
- `module.shop.aws_security_group.main`

#### To create with `terraform apply`

- `module.base.aws_route53_delegation_set.main`

#### To add to Terraform and create

- `zone_id` for example.fr and shop.company

#### Imported

- `module.base.aws_route53_zone.main`
- `module.base.aws_key_pair.main`
- `module.base.aws_route53_record.ses_verification_record`


## Misc

```
aws \
  --profile=shop-test \
  ec2 describe-instances \
  --filters "Name=tag:Name,Values=tk" \
  --query "Reservations[].Instances[].InstanceId" \
  | jq .

aws \
  --profile=shop-test \
  ec2 \
  start-instances \
  --instance-ids "i-0123456789abcdef1"
```

```
terraform \
  import \
  module.base.aws_route53_record.ses_verification_record \
  Z0EXAMPLEZON02__amazonses.example.com_TXT
```


## Potential test2 → prod delivery scheme

- spin up a brand new instance in AWS account `shop`
  - with TLD .gq
  - with Ansible parameter "prod"
  - but disable backups
  - manually generate certs
- add `.com` certificates
- selectively use Ansible to update the conf of
  - nginx, postfix, monit, collectd, … (?)
  - DB: all 4(?) values
- switch EIP from old-prod to new-prod

## Commands to switch EIPs for prod delivery

```bash
terraform destroy \
  --target 'module.shop["green"].aws_eip.instance[0]' \
  --target 'module.shop["green"].aws_route53_record.dkim[0]' \
  --target 'module.shop["green"].aws_route53_record.dkim[1]' \
  --target 'module.shop["green"].aws_route53_record.dkim[2]' \
  --target 'module.shop["green"].aws_route53_record.dmarc' \
  --target 'module.shop["green"].aws_route53_record.mx' \
  --target 'module.shop["green"].aws_route53_record.parent_domain' \
  --target 'module.shop["green"].aws_route53_record.spf' \
  --target 'module.shop["green"].aws_route53_record.sub_domain["admin"]' \
  --target 'module.shop["green"].aws_route53_record.sub_domain["blog"]' \
  --target 'module.shop["green"].aws_route53_record.sub_domain["www"]'
```

## Rework of this README

File hierarchy:

```
├── modules
│   ├── environment
│   ├── zone_base
│   ├── instance
│   └── dns_records
└── env
    ├── test
    │   ├── environment
    │   ├── zone_base
    │   └── instance_with_dns
    └── prod
        └── …
```

- `./modules/environment`: base resources required for an environment (such as
  `test` and `prod`). Currently declares an authentication key pair and a
  backup S3 bucket.
- `./modules/zone_base`: base DNS zone and SES resources for a "domain name"
  (ie "example.com", "example.fr", …).
- `./modules/instance`: resources required for an EC2 instance without anything
  to do with DNS records.
- `./modules/dns_records`: DNS records linking an `instance` to a `zone_base`.

- `./env/test/environment`: declares one instance of `./module/environment` to
  setup the common resources for the `test` environment. Resources in this
  directory are long lived, they should seldom need update and are available
  for all other modules which is the reason why they are isolated in their own
  module. This module doesn't depend on any other.
- `./env/test/zone_base`: declares one or more DNS zones and corresponding SES
  resources for `test` (currently `.ml` and `.tk`). Resources in this directory
  are long lived. They are isolated in their own module because they are rather
  long to provision mostly because they start DNS and SES verification
  processes that we don't want to have to go through more than once. This
  module doesn't depend on any other module.
- `./env/test/instance_with_dns`: declares multiple instances of
  `./module/instance` along with a corresponding `./module/dns_records` thus
  effectively linking the instance to a domain name. Resources in this
  directory can be short lived if need be. Resources from this module's
  `instance` don't depend on any other module/resource. Resources from this
  module's `dns_records` depend on:
  - output of external module `env/test/environment` and `env/test/zone_base`
    which are accessed through S3 data sources
  - the inner `instance` module which data is read through a data source to
    dynamically list EC2 instances

```bash
$ cd env/test/environment
$ terraform state list
# Test environment declares the "test specific" EC2 authentication key pair
# and the "test specific" backup bucket
module.environment.aws_key_pair.main
module.environment.aws_s3_bucket.backup
```

```bash
$ cd env/test/zone_base
$ terraform state list
# Test zone_base declares 2 DNS zones:
module.zone_base["example.ml"].aws_route53_delegation_set.main
module.zone_base["example.ml"].aws_route53_zone.main
module.zone_base["example.ml"].aws_ses_domain_identity.main
module.zone_base["example.ml"].aws_route53_record.ses_verification_record
module.zone_base["example.ml"].aws_ses_domain_dkim.main
#
module.zone_base["example.tk"].aws_route53_delegation_set.main
module.zone_base["example.tk"].aws_route53_zone.main
module.zone_base["example.tk"].aws_ses_domain_identity.main
module.zone_base["example.tk"].aws_route53_record.ses_verification_record
module.zone_base["example.tk"].aws_ses_domain_dkim.main
```

```bash
$ cd env/test/instance_with_dns
$ terraform state list
# Terraform data source to fetch instances info
data.aws_instance.instances["green"]
data.aws_instance.instances["yellow"]
# Terraform remote state for the environment and zone_base both persisted on S3
data.terraform_remote_state.environment
data.terraform_remote_state.zone_base
# EC2 resources for green instance
module.instance["green"].aws_iam_access_key.ses_smtp
module.instance["green"].aws_iam_instance_profile.ec2_profile
module.instance["green"].aws_iam_policy.s3_bucket_access
module.instance["green"].aws_iam_policy_attachment.attach_s3_policy_ec2
module.instance["green"].aws_iam_role.ec2_assume
module.instance["green"].aws_iam_user.ses_smtp
module.instance["green"].aws_iam_user_policy.ses_smtp
module.instance["green"].aws_instance.main
module.instance["green"].aws_security_group.main
# .ml EIP pointing at previous instance
module.dns_records["example.ml"].aws_eip.instance[0]
# .ml DNS records pointing at previous EIP
module.dns_records["example.ml"].aws_route53_record.parent_domain
module.dns_records["example.ml"].aws_route53_record.sub_domain["admin"]
module.dns_records["example.ml"].aws_route53_record.sub_domain["blog"]
module.dns_records["example.ml"].aws_route53_record.sub_domain["www"]
module.dns_records["example.ml"].aws_route53_record.mx
module.dns_records["example.ml"].aws_route53_record.spf
module.dns_records["example.ml"].aws_route53_record.dkim[0]
module.dns_records["example.ml"].aws_route53_record.dkim[1]
module.dns_records["example.ml"].aws_route53_record.dkim[2]
module.dns_records["example.ml"].aws_route53_record.dmarc

# Same for tk
module.dns_records["example.tk"].aws_eip.instance[0]
module.dns_records["example.tk"].aws_route53_record.dkim[0]
module.dns_records["example.tk"].aws_route53_record.dkim[1]
module.dns_records["example.tk"].aws_route53_record.dkim[2]
module.dns_records["example.tk"].aws_route53_record.dmarc
module.dns_records["example.tk"].aws_route53_record.mx
module.dns_records["example.tk"].aws_route53_record.parent_domain
module.dns_records["example.tk"].aws_route53_record.spf
module.dns_records["example.tk"].aws_route53_record.sub_domain["admin"]
module.dns_records["example.tk"].aws_route53_record.sub_domain["blog"]
module.dns_records["example.tk"].aws_route53_record.sub_domain["www"]
module.instance["yellow"].aws_iam_access_key.ses_smtp
module.instance["yellow"].aws_iam_instance_profile.ec2_profile
module.instance["yellow"].aws_iam_policy.s3_bucket_access
module.instance["yellow"].aws_iam_policy_attachment.attach_s3_policy_ec2
module.instance["yellow"].aws_iam_role.ec2_assume
module.instance["yellow"].aws_iam_user.ses_smtp
module.instance["yellow"].aws_iam_user_policy.ses_smtp
module.instance["yellow"].aws_instance.main
module.instance["yellow"].aws_security_group.main
```


TODO give example of `terraform state mv …` and `terraform import … …`


## Examples of `terraform import`

```bash
terraform import 'module.zone_base["example.com"].aws_route53_delegation_set.main'
terraform import 'module.zone_base["example.fr"].aws_route53_zone.main' Z0EXAMPLEZON01
terraform import 'module.zone_base["example.com"].aws_route53_zone.main' Z0EXAMPLEZON02
terraform import 'module.zone_base["example.com"].aws_ses_domain_identity.main' example.com
terraform import 'module.zone_base["example.fr"].aws_ses_domain_identity.main' example.fr
terraform import 'module.zone_base["example.fr"].aws_route53_record.ses_verification_record' example.fr
terraform import 'module.zone_base["example.com"].aws_route53_record.ses_verification_record' example.com
terraform import 'module.zone_base["example.com"].aws_route53_record.ses_verification_record' Z0EXAMPLEZON02__amazonses.example.com_TXT
terraform import 'module.zone_base["example.fr"].aws_route53_record.ses_verification_record' Z0EXAMPLEZON01__amazonses.example.fr_TXT
terraform import 'module.zone_base["example.fr"].aws_route53_record.ses_verification_record'
terraform import 'module.zone_base["example.com"].aws_ses_domain_dkim.main' example.com
terraform import aws_eip.main_prod 203.0.113.10
terraform import 'module.dns_records_sets["example.fr"].aws_route53_record.parent_domain' example.fr
terraform import 'module.dns_records_sets["example.fr"].aws_route53_record.parent_domain' Z0EXAMPLEZON01_example.fr_A
terraform import 'module.dns_records_sets["example.com"].aws_route53_record.parent_domain' Z0EXAMPLEZON02_example.com_A
terraform import 'module.dns_records_sets["example.fr"].aws_route53_record.sub_domain["admin"]' Z0EXAMPLEZON01_admin.example.fr_A
terraform import 'module.dns_records_sets["example.fr"].aws_route53_record.sub_domain["blog"]' Z0EXAMPLEZON01_blog.example.fr_A
terraform import 'module.dns_records_sets["example.fr"].aws_route53_record.sub_domain["www"]' Z0EXAMPLEZON01_www.example.fr_A
terraform import 'module.dns_records_sets["example.com"].aws_route53_record.sub_domain["www"]' Z0EXAMPLEZON02_www.example.com_A
terraform import 'module.dns_records_sets["example.com"].aws_route53_record.sub_domain["blog"]' Z0EXAMPLEZON02_blog.example.com_A
terraform import 'module.dns_records_sets["example.com"].aws_route53_record.sub_domain["admin"]' Z0EXAMPLEZON02_admin.example.com_A
terraform import --target=module.instances["old_prod"]
terraform import --target='module.instances["old_prod"]'
terraform import module.instances["old_prod"] i-0123456789abcdef0
terraform import 'module.instances["old_prod"]' i-0123456789abcdef0
terraform import 'instances["old_prod"]' i-0123456789abcdef0
terraform import 'module.instances["old_prod"].aws_instance.main' i-0123456789abcdef0
terraform import 'module.dns_records_sets["example.com"].aws_route53_record.dkim[0]' Z0EXAMPLEZON02_mrfnghojnvosvjk56ta7l47msrivhhg4._domainkey.example.com_CNAME
terraform import 'module.dns_records_sets["example.com"].aws_route53_record.dkim[1]' Z0EXAMPLEZON02_tb7naxle6w4lfwn5j2ffrw235gxpzbjk._domainkey.example.com_CNAME
terraform import 'module.dns_records_sets["example.com"].aws_route53_record.dkim[2]' Z0EXAMPLEZON02_ujfzwdqqlrplwvltr7havlnu7ehyqxms._domainkey.example.com_CNAME
terraform import 'module.dns_records_sets["example.com"].aws_route53_record.dmarc' Z0EXAMPLEZON02__dmarc.example.com_TXT
terraform import 'module.dns_records_sets["example.com"].aws_route53_record.mx' Z0EXAMPLEZON02_example.com_MX
terraform import 'module.dns_records_sets["example.com"].aws_route53_record.spf' Z0EXAMPLEZON02_example.com_TXT
terraform import 'module.dns_records_sets["example.com"].aws_route53_record.dkim[0]' Z0EXAMPLEZON02_tb7naxle6w4lfwn5j2ffrw235gxpzbjk._domainkey_CNAME
terraform import 'module.dns_records_sets["example.com"].aws_route53_record.dkim[1]' Z0EXAMPLEZON02_mrfnghojnvosvjk56ta7l47msrivhhg4._domainkey_CNAME
terraform import 'module.dns_records_sets["example.com"].aws_route53_record.dkim[2]' Z0EXAMPLEZON02_ujfzwdqqlrplwvltr7havlnu7ehyqxms._domainkey_CNAME
```
