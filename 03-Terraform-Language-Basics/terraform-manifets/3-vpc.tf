# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute
# Resource: VPC
resource "google_compute_network" "myvpc" {
  name = "vpc1"
  auto_create_subnetworks = false   
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
# Resource: Subnet
resource "google_compute_subnetwork" "mysubnet" {
  name = "subnet1"
  region = var.region
  # ip_cidr_range: 
  ip_cidr_range = "10.128.0.0/20"
  network = google_compute_network.myvpc.id 
}