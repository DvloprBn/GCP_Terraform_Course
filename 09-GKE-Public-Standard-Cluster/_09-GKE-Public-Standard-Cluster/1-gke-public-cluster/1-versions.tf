# https://github.com/stacksimplify/terraform-on-google-kubernetes-engine/blob/main/09-GKE-Public-Standard-Cluster/README.md
# Create Cloud Storage Bucket and Update the bucket details in 1-versions.tf
# Terraform Settings Block
terraform {
  required_version = ">= 1.9"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 5.42.0"
    }
  }
  backend "gcs" {
    bucket = "terraform-on-gcp-gke-ben"
    # folder donde se guardaran los recursos 
    prefix = "dev/gke-cluster-public"    
  }
}

# Terraform Provider Block
provider "google" {
  project = var.gcp_project
  region = var.gcp_region1
}


/*

Install kubectl cli
Create Terraform configs for GKE standard public cluster
Create GKE cluster using Terraform
Verify resources

*/