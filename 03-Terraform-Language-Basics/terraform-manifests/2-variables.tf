variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
  default = "tutorialgcp001"
}

variable "region" {
  description = "Región de GCP"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona de GCP"
  type        = string
  default     = "us-central1-a"
}
