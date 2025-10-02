<!-- markdownlint-disable -->

<a href="https://www.mjraadi.dev/"><img src="https://github.com/mjraadi/terraform-aws-module-template/blob/main/docs/banner.jpg?raw=true" alt="Banner"/></a><br/><p align="right"> <a href="https://registry.terraform.io/modules/mjraadi/module-template/aws/latest"></a></a> </a>

<!-- markdownlint-restore -->
<!--
  ***** CAUTION: DO NOT EDIT ABOVE THIS LINE ******
-->

# Terraform AWS Module - Route53 Zones Management Role

## Description

This module creates a single IAM role that allows cross-account DNS management for specified Route53 hosted zones. It's designed to be simple, secure, and reusable across different environments.

## Features

- ✅ **Simple**: One role, clear inputs, predictable outputs
- ✅ **Secure**: Organization boundary + role pattern restrictions + least privilege
- ✅ **Flexible**: Configurable permissions, session duration, and trusted accounts
- ✅ **Reusable**: Environment-agnostic, instantiate multiple times for different use cases

## Usage

```hcl
module "dns_role_production" {
  source = "../modules/cross-account-dns-role"

  role_name               = "DNSManagement-Production"
  role_description        = "DNS management for production domains"
  trusted_account_ids     = ["123456789012"]            # Production account(s)
  hosted_zone_ids         = ["Z1234567890ABC"]          # Production hosted zones
  max_session_duration    = 3600                        # 1 hour for production
  allowed_role_patterns   = [
    "AWSReservedSSO_AWSAdministrator*",
    "CloudNation-Administrator",
    "github-ci"
  ]
}

module "dns_role_nonprod" {
  source = "../modules/cross-account-dns-role"

  role_name               = "DNSManagement-NonProduction"
  role_description        = "DNS management for development and staging domains"
  trusted_account_ids     = ["987654321098", "456789012345"] # Dev/staging accounts
  hosted_zone_ids         = ["Z0987654321XYZ", "Z5432109876DEF"] # Dev hosted zones
  max_session_duration    = 14400                              # 4 hours for dev
}
```

## What This Module Creates

1. **IAM Role**: Cross-account assumable role with trust policy
2. **IAM Policy**: Route53 permissions for specified hosted zones

## Route53 Permissions Granted

The created role has the following Route53 permissions by default:

- `route53:ChangeResourceRecordSets` - Create, update, delete DNS records
- `route53:GetChange` - Check the status of DNS changes
- `route53:GetHostedZone` - Get hosted zone information
- `route53:ListResourceRecordSets` - List DNS records in a hosted zone
- `route53:ListHostedZones` - List all hosted zones (for discovery)
- `route53:ListHostedZonesByName` - List hosted zones by name

## Security Features

- **Organization Boundary**: Only accounts in your AWS Organization can assume the role
- **Account Restrictions**: Only specified trusted accounts can assume the role
- **Role Pattern Restrictions**: Only IAM roles matching specified patterns can assume the role
- **Resource Scope**: Only specified hosted zones can be managed
- **Session Limits**: Configurable session duration for time-bounded access
- **Least Privilege**: Minimal required Route53 permissions only

## Example Usage in Target Accounts

Once deployed, target accounts can use the role:

### Terraform Provider

```hcl
provider "aws" {
  alias = "dns_management"

  assume_role {
    role_arn     = "arn:aws:iam::SHARED-ACCOUNT:role/DNSManagement-Production"
    session_name = "terraform-dns-session"
  }
}

resource "aws_route53_record" "example" {
  provider = aws.dns_management

  zone_id = "Z1234567890ABC"
  name    = "api.example.com"
  type    = "A"
  ttl     = 300
  records = ["1.2.3.4"]
}
```

## Requirements

- AWS Organization configured in the target account
- Target accounts must be members of the same AWS Organization
- Hosted zones must exist before using this module

## Update Documentation

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.95.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hosted_zone_ids"></a> [hosted\_zone\_ids](#input\_hosted\_zone\_ids) | List of Route53 hosted zone IDs this role can manage | `list(string)` | n/a | yes |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | Description for the IAM role | `string` | n/a | yes |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the IAM role to create | `string` | n/a | yes |
| <a name="input_trusted_account_ids"></a> [trusted\_account\_ids](#input\_trusted\_account\_ids) | List of AWS account IDs that can assume this role | `list(string)` | n/a | yes |
| <a name="input_allowed_role_patterns"></a> [allowed\_role\_patterns](#input\_allowed\_role\_patterns) | List of IAM role name patterns that can assume this role (supports wildcards) | `list(string)` | <pre>[<br/>  "CloudNation-Administrator"<br/>]</pre> | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration in seconds (1 hour to 12 hours) | `number` | `3600` | no |
| <a name="input_route53_actions"></a> [route53\_actions](#input\_route53\_actions) | List of Route53 actions this role can perform | `list(string)` | <pre>[<br/>  "route53:ChangeResourceRecordSets",<br/>  "route53:GetChange",<br/>  "route53:GetHostedZone",<br/>  "route53:ListResourceRecordSets",<br/>  "route53:ListHostedZones",<br/>  "route53:ListHostedZonesByName"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_assume_role_command"></a> [assume\_role\_command](#output\_assume\_role\_command) | AWS CLI command to assume this role |
| <a name="output_policy_arn"></a> [policy\_arn](#output\_policy\_arn) | ARN of the created IAM policy |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the created IAM role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Name of the created IAM role |
| <a name="output_terraform_provider_config"></a> [terraform\_provider\_config](#output\_terraform\_provider\_config) | Terraform provider configuration for assuming this role |
<!-- END_TF_DOCS -->
