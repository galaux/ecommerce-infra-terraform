# example Terraform

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
