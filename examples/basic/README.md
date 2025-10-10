# Basic Example

This example demonstrates the basic usage of the Route53 DNS Management Role module. It creates an IAM role that can be assumed by trusted AWS accounts to manage DNS records in specified Route53 hosted zones.

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0.0
- AWS provider >= 5.0.0

## Configuration

Before deploying this example, you need to update the following variables in `variables.tf` or create a `terraform.tfvars` file:

- `trusted_account_ids`: Replace with the actual AWS account IDs that should be able to assume this role
- `hosted_zone_ids`: Replace with the actual Route53 hosted zone IDs that this role should manage

### Example terraform.tfvars

```hcl
role_name           = "Route53DNSManagementRole"
role_description    = "Cross-account role for managing Route53 DNS records"
trusted_account_ids = ["111111111111", "222222222222"]
hosted_zone_ids     = ["Z1D633PJN98FT9", "Z8VLZEXAMPLE"]
```

## Usage

1. Clone this repository
2. Navigate to this example directory
3. Update the variables as described above
4. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

## Assuming the Role

After deployment, the role can be assumed using the AWS CLI command provided in the output:

```bash
aws sts assume-role --role-arn <role_arn> --role-session-name dns-management
```

Or use the Terraform provider configuration also provided in the output to assume the role in other Terraform configurations.

<!-- BEGIN_TF_DOCS -->
## Providers

No providers.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_role_patterns"></a> [allowed\_role\_patterns](#input\_allowed\_role\_patterns) | List of IAM role name patterns that can assume this role (supports wildcards) | `list(string)` | <pre>[<br/>  "CloudNation-Administrator",<br/>  "TerraformExecutionRole"<br/>]</pre> | no |
| <a name="input_hosted_zone_ids"></a> [hosted\_zone\_ids](#input\_hosted\_zone\_ids) | List of Route53 hosted zone IDs this role can manage | `list(string)` | <pre>[<br/>  "Z1234567890ABC"<br/>]</pre> | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration in seconds (1 hour to 12 hours) | `number` | `3600` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | Description for the IAM role | `string` | `"Cross-account role for managing Route53 DNS records"` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the IAM role to create | `string` | `"Route53DNSManagementRole"` | no |
| <a name="input_route53_actions"></a> [route53\_actions](#input\_route53\_actions) | List of Route53 actions this role can perform | `list(string)` | <pre>[<br/>  "route53:ChangeResourceRecordSets",<br/>  "route53:GetChange",<br/>  "route53:GetHostedZone",<br/>  "route53:ListResourceRecordSets",<br/>  "route53:ListHostedZones",<br/>  "route53:ListHostedZonesByName"<br/>]</pre> | no |
| <a name="input_trusted_account_ids"></a> [trusted\_account\_ids](#input\_trusted\_account\_ids) | List of AWS account IDs that can assume this role | `list(string)` | <pre>[<br/>  "123456789012"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_assume_role_command"></a> [assume\_role\_command](#output\_assume\_role\_command) | AWS CLI command to assume this role |
| <a name="output_policy_arn"></a> [policy\_arn](#output\_policy\_arn) | ARN of the created IAM policy |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the created IAM role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Name of the created IAM role |
| <a name="output_terraform_provider_config"></a> [terraform\_provider\_config](#output\_terraform\_provider\_config) | Terraform provider configuration for assuming this role |
<!-- END_TF_DOCS -->
