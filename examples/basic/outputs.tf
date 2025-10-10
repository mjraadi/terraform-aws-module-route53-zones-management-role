output "role_arn" {
  description = "ARN of the created IAM role"
  value       = module.route53_dns_management_role.role_arn
}

output "role_name" {
  description = "Name of the created IAM role"
  value       = module.route53_dns_management_role.role_name
}

output "policy_arn" {
  description = "ARN of the created IAM policy"
  value       = module.route53_dns_management_role.policy_arn
}

output "assume_role_command" {
  description = "AWS CLI command to assume this role"
  value       = module.route53_dns_management_role.assume_role_command
}

output "terraform_provider_config" {
  description = "Terraform provider configuration for assuming this role"
  value       = module.route53_dns_management_role.terraform_provider_config
}