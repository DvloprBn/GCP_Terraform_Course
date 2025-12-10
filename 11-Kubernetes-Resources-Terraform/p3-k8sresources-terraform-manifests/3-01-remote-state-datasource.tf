# Terraform Remote State Datasource
# terraform_remote_state
# es posible decir que se genera un set de datos 
# informacion que ira de Project-1 a Project-3
data "terraform_remote_state" "gke" {
  backend = "gcs"
  config = {
    bucket = "terraform-on-gcp-gke-ben"
    prefix = "dev/gke-cluster-public"
  }  
}

# Outputs
# p1_gke_cluster_name
output "p1_gke_cluster_name" {
  value = data.terraform_remote_state.gke.outputs.gke_cluster_name
}

# p1_gke_cluster_location
output "p1_gke_cluster_location" {
  value = data.terraform_remote_state.gke.outputs.gke_cluster_location
}