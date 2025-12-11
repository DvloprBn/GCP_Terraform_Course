# Terraform Settings Block
terraform {
  required_version = ">= 1.9"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 5.42.0"
    }
    # https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.31"
    }      
  }

  # Add Remote Backend as Cloud Storage Bucket
  backend "gcs" {
    bucket = "terraform-on-gcp-gke-ben"
    prefix = "dev/k8s-demo1"    
  }  
}

/*

En este Projecto 3 es donde se ejecutaran las instrucciones de Terrafomr init, plan & apply

*/

