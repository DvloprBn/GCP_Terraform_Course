# Define Local Values in Terraform
# https://developer.hashicorp.com/terraform/language/values/locals
# https://developer.hashicorp.com/terraform/language/values/outputs
locals {
  owners = var.business_divsion
  # dev, stage, prod
  environment = var.environment
  name = "${var.business_divsion}-${var.environment}"
  #name = "${local.owners}-${local.environment}"
  common_tags = {
    owners = local.owners
    environment = local.environment
  }
} 



/*

Add a locals block when you want to reuse an expression throughout your configuration. 
You can define the locals block in any module 
and can assign any valid Terraform expression as its value

- Input variables: are like functions "arguments".
- Output Values: are like fucntion "return values".

Para este caso obtendra los valores directamente desde terraform.tfvars

*/