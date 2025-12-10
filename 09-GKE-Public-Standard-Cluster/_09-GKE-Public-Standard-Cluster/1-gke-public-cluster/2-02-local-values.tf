# https://developer.hashicorp.com/terraform/language/values/locals
/*
  Local values are similar to function-scoped variables in other programming languages. 
  Local values assign names to expressions, letting you use the name multiple times within a module instead of repeating that expression.
*/
# Define Local Values in Terraform
locals {
  owners = var.business_divsion
  environment = var.environment
  name = "${var.business_divsion}-${var.environment}"
  #name = "${local.owners}-${local.environment}"
  common_tags = {
    owners = local.owners
    environment = local.environment
  }
} 



# 