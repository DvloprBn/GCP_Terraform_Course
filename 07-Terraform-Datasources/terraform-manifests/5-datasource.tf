# Terraform Datasources
# https://developer.hashicorp.com/terraform/language/data-sources
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones
/* Datasource: Get a list of Google 
Compute zones that are UP in a region */
# data source - Data Block
# obtiene la informacion desde una fuente de origen externa
data "google_compute_zones" "available" {    
  status = "UP"
}

# Output value
# muestra el listado definido en el bloque DATA
output "compute_zones" {
  description = "List of compute zones"
  value = data.google_compute_zones.available.names
}