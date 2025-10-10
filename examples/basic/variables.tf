variable "role_name" {
  description = "Name of the IAM role to create"
  type        = string
  default     = "Route53DNSManagementRole"
}

variable "role_description" {
  description = "Description for the IAM role"
  type        = string
  default     = "Cross-account role for managing Route53 DNS records"
}

variable "trusted_account_ids" {
  description = "List of AWS account IDs that can assume this role"
  type        = list(string)
  default     = ["123456789012"] # Replace with actual account IDs
}

variable "allowed_role_patterns" {
  description = "List of IAM role name patterns that can assume this role (supports wildcards)"
  type        = list(string)
  default     = ["CloudNation-Administrator", "TerraformExecutionRole"]
}

variable "hosted_zone_ids" {
  description = "List of Route53 hosted zone IDs this role can manage"
  type        = list(string)
  default     = ["Z1234567890ABC"] # Replace with actual hosted zone IDs
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds (1 hour to 12 hours)"
  type        = number
  default     = 3600 # 1 hour
}

variable "route53_actions" {
  description = "List of Route53 actions this role can perform"
  type        = list(string)
  default = [
    "route53:ChangeResourceRecordSets",
    "route53:GetChange",
    "route53:GetHostedZone",
    "route53:ListResourceRecordSets",
    "route53:ListHostedZones",
    "route53:ListHostedZonesByName"
  ]
}