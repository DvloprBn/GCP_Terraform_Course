# Terraform Settings Block
terraform {
  required_version = ">= 1.8"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 5.32.0"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs
# Terraform Provider Block
provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

