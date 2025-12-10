# Terraform Settings Block
terraform {
  required_version = ">= 1.9"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 5.42.0"
    }
  }
  # es necesario asegurar que el nombre del Bucket es correcto 
  # caso contrario se recibira un mensaje de error:
  /*
    Error: Failed to get existing workspaces: 
    querying Cloud Storage failed: googleapi: 
    Error 403: dvloprbn@gmail.com does not have storage.objects.list access 
    to the Google Cloud Storage bucket. 
    Permission 'storage.objects.list' denied on resource (or it may not exist)., forbidden

  */
  backend "gcs" {
    bucket = "terraform-on-gcp-gke-ben"
    prefix = "dev/gke-cluster-public"    
  }
}

# Terraform Provider Block
provider "google" {
  project = var.gcp_project
  region = var.gcp_region1
}