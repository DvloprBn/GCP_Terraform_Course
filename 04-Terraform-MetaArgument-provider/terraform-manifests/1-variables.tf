variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
  default = "tutorialgcp001"
}

variable "regionUS" {
  description = "Región de GCP"
  type        = string
  default     = "us-central1"
}

variable "zoneUS" {
  description = "Zona de GCP"
  type        = string
  default     = "us-central1-a"
}

variable "regionEU" {
  description = "Región de GCP"
  type        = string
  default     = "europe-west1"
}

variable "zoneEU" {
  description = "Zona de GCP"
  type        = string
  default     = "europe-west1-a"
}
