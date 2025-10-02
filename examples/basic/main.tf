#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

module "route53_dns_management_role" {
  source = "../.."

  role_name        = var.role_name
  role_description = var.role_description

  trusted_account_ids   = var.trusted_account_ids
  allowed_role_patterns = var.allowed_role_patterns
  hosted_zone_ids       = var.hosted_zone_ids
  max_session_duration  = var.max_session_duration
  route53_actions       = var.route53_actions
}
