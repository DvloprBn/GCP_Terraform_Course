# Terraform Settings Block
terraform {
  required_version = ">= 1.9"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 5.42.0"
    }
  }
  
  # Add Remote Backend as Cloud Storage Bucket 
  backend "gcs" {
    # terraform-on-gcp-gke
    # el nombre del bucket debe ser unico a nivel global, lo que indica que una vez creado el bucket, ese nombre no se podra utilizar 
    bucket = "terraform-on-gcp-gke-ben"
    # creara un folder dentro del bucket y se creara el archivo que almacenara el estado de terraform
    prefix = "dev/gke-cluster-public"    
  }
}

# Terraform Provider Block
provider "google" {
  project = var.gcp_project
  region = var.gcp_region1
}