module "iam_assumable_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "~> 3.0"

  trusted_role_arns = var.allowed_admin_arns

  create_admin_role = true
  # Not enforcing MFA because would need to be setup on local AWS CLI
  admin_role_requires_mfa = false

  create_poweruser_role = false

  create_readonly_role = false
}
