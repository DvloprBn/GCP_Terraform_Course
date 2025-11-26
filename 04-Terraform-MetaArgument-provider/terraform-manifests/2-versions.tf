# Terraform Settings Block
terraform {
  required_version = ">= 1.8"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 5.34.0"
    }
  }
}

# Es posible definir multiples configuraciones del mismo proveedor
# y es posible seleccionar cuan usar en un recurso o modulo.
# para ser utilizado desde un recurso se implementa:
# provider = <providerName>.<alias>
# provider = google.us-central1   # define el proveedor a usar.

# Terraform Provider-1: us-central1
provider "google" {
  project = var.project_id
  region = var.regionUS
  alias = "us-central1"    # no permite el uso de variables
}

# Terraform Provider-2: europe-west1
provider "google" {
  project = var.project_id
  region = var.regionEU
  alias = "europe-west1"    # no permite el uso de variables
}