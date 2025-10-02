variable "role_name" {
  description = "Name of the IAM role to create"
  type        = string
}

variable "role_description" {
  description = "Description for the IAM role"
  type        = string
}

variable "trusted_account_ids" {
  description = "List of AWS account IDs that can assume this role"
  type        = list(string)
}

variable "allowed_role_patterns" {
  description = "List of IAM role name patterns that can assume this role (supports wildcards)"
  type        = list(string)
  default     = ["CloudNation-Administrator"]
}

variable "hosted_zone_ids" {
  description = "List of Route53 hosted zone IDs this role can manage"
  type        = list(string)
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds (1 hour to 12 hours)"
  type        = number
  default     = 3600  # 1 hour
  
  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Session duration must be between 3600 (1 hour) and 43200 (12 hours) seconds."
  }
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
