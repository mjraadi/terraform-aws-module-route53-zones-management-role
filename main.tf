# Get current AWS account and organization information
data "aws_caller_identity" "current" {}
data "aws_organizations_organization" "current" {}

#------------------------------------------------------------------------------
# IAM Role for Cross-Account DNS Management
#------------------------------------------------------------------------------
resource "aws_iam_role" "dns_management" {
  name                 = var.role_name
  description          = var.role_description
  max_session_duration = var.max_session_duration

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            for account_id in var.trusted_account_ids :
            "arn:aws:iam::${account_id}:root"
          ]
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:PrincipalOrgID" = data.aws_organizations_organization.current.id
          }
          ArnLike = {
            "aws:PrincipalArn" = flatten([
              for account_id in var.trusted_account_ids : [
                for role_pattern in var.allowed_role_patterns :
                "arn:aws:iam::${account_id}:role/${role_pattern}"
              ]
            ])
          }
        }
      }
    ]
  })
}

#------------------------------------------------------------------------------
# IAM Policy for Route53 DNS Management
#------------------------------------------------------------------------------
resource "aws_iam_policy" "dns_management" {
  name        = "${var.role_name}-Policy"
  description = "Policy for ${var.role_description}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = var.route53_actions
        Resource = [
          for zone_id in var.hosted_zone_ids :
          "arn:aws:route53:::hostedzone/${zone_id}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "route53:GetChange"
        ]
        Resource = "arn:aws:route53:::change/*"
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones"
        ]
        Resource = "*"
      }
    ]
  })
}

#------------------------------------------------------------------------------
# Attach Policy to Role
#------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "dns_management" {
  role       = aws_iam_role.dns_management.name
  policy_arn = aws_iam_policy.dns_management.arn
}
