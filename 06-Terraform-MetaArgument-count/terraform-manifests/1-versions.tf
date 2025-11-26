# https://developer.hashicorp.com/terraform/tutorials/0-13/count

/*
The count argument replicates the given resource or module a specific number of times with an incrementing counter. 
It works best when resources will be identical, or nearly so.

*/


# Terraform Settings Block
terraform {
  required_version = ">= 1.8"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 5.26.0"
    }
  }
}

# Terraform Provider Block
provider "google" {
  project = var.gcp_project
  region = var.gcp_region1
}