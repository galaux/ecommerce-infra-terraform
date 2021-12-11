# Shop infrastructure — Terraform

Terraform code for the AWS side of a small PrestaShop online shop: EC2 hosts, Route53 zones and
records, SES sending identities, IAM roles and users, S3 backup buckets, and one Elastic IP used to
move production traffic from one instance to another.

The Ansible roles that configure these instances are in a separate repository.

**Status:** archived. Last changed in 2021. The shop runs on something else now. This is published
as a work sample, not as code to run.

## Modules are split by how long resources live

Resources are grouped by how long they last and how painful they are to recreate, not by resource
type. This is the main idea in the repository.

```
modules/
  environment      key pair + backup bucket + admin role, shared across one environment
  zone_base        one DNS zone: Route53 zone, delegation set, SES identity and DKIM
  instance         one EC2 host: security group, IAM role/profile, SES SMTP user, cost alarm
  dns_records      the records that point a domain at an instance
  dns_records_mailchimp   MailChimp's own DKIM records, kept apart
env/
  test/{environment,zone_base,instance_with_dns}
  prod/{environment,zone_base,instance_with_dns}
```

Each `env/*/*` directory is a root module with its own state file:

- **`environment`** and **`zone_base`** hold the slow things. DNS delegation and SES domain
  verification take time and need steps outside Terraform, so a normal apply must never touch them.
  They depend on nothing else.
- **`instance_with_dns`** holds the throwaway things. Instances can be created and destroyed here
  without putting a DNS zone or a verified sending identity at risk.

The throwaway layer reads the slow layers through `terraform_remote_state` on the S3 backend, so the
dependency only points one way:

```hcl
zone_base = data.terraform_remote_state.zone_base.outputs.zone_base[each.key]
```

## Blue/green with an Elastic IP

Instances are named after colours — `brown` and `purple` in production, `green` and `yellow` in
test. DNS points at an Elastic IP, not at an instance:

```hcl
module "dns_records_sets" {
  for_each = {
    "example.com" = { target = aws_eip.main_prod }
  }
  source    = "../../../modules/dns_records"
  zone_base = data.terraform_remote_state.zone_base.outputs.zone_base[each.key]
  target_ip = each.value.target.public_ip
}
```

To release, I built the new colour next to the old one, configured it with Ansible, checked it, then
moved the Elastic IP. The DNS records never change, so there is no wait for propagation or TTL.
Rolling back is the same move in reverse.

An instance is put in or taken out of service by switching `target` between `aws_eip.main_prod` and
`module.instances["<colour>"]`. That is why both lines appear, one commented out, in the `env`
directories.

## What each module does

**`modules/instance`** is the biggest one:

- a security group with configurable port ranges and an `http_allowed_ips` list, so a staging shop
  can be opened to a few addresses instead of the whole internet
- an IAM role and instance profile allowed to do exactly two things: write to that environment's
  backup bucket, and update its own Route53 records
- one SES SMTP IAM user per instance, with the generated credentials exported as `sensitive` outputs
  for Ansible to read
- `aws_cloudwatch_metric_alarm "stop_if_unused"`, which stops an idle test instance so a forgotten
  staging host does not run up a bill

**`modules/zone_base`** creates the zone with an explicit `aws_route53_delegation_set`, so the
nameservers stay the same even if the zone is destroyed and recreated.

**`modules/dns_records`** builds every record for a domain in one place: apex A record, `for_each`
subdomains, MX, SPF, DMARC and the three SES DKIM CNAMEs.

## Running it

Apply each layer from its own directory, slow layers first:

```sh
cd env/test/environment      && terraform init && terraform apply
cd ../zone_base              && terraform init && terraform apply
cd ../instance_with_dns      && terraform init && terraform apply
```

State lives in S3 (`backend "s3"`). `terraform.tfstate*` and `.terraform/` are not tracked.

## What is wrong with it

- **No CI and no `terraform validate` in a pipeline.** I read the plans by hand.
- **No module version pinning.** Modules are referenced by relative path. Only
  `.terraform.lock.hcl` pins the providers.
- **One AWS account.** I set up separate `test` and `prod` accounts and then gave up: both
  environments share a parent domain, and splitting Route53 across accounts needed more machinery
  than this shop was worth.
- **Ansible runs separately, by hand.** That was on purpose — provisioners are a last resort — but
  it means creating a working instance is two commands and a manual step, not one.
- **Instances are started and stopped outside Terraform**, with `aws ec2 start-instances`.
