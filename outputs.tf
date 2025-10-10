output "role_arn" {
  description = "ARN of the created IAM role"
  value       = aws_iam_role.dns_management.arn
}

output "role_name" {
  description = "Name of the created IAM role"
  value       = aws_iam_role.dns_management.name
}

output "policy_arn" {
  description = "ARN of the created IAM policy"
  value       = aws_iam_policy.dns_management.arn
}

output "assume_role_command" {
  description = "AWS CLI command to assume this role"
  value       = "aws sts assume-role --role-arn ${aws_iam_role.dns_management.arn} --role-session-name dns-management"
}

output "terraform_provider_config" {
  description = "Terraform provider configuration for assuming this role"
  value = {
    alias = replace(lower(var.role_name), "-", "_")
    assume_role = {
      role_arn = aws_iam_role.dns_management.arn
    }
  }
}
