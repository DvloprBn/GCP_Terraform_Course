
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
# Firewall Rule: SSH
resource "google_compute_firewall" "fw_ssh" {
  name = "fwrule-allow-ssh22"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  # (Optional) Direction of traffic to which this firewall applies; 
  # default is INGRESS. 
  # Note: For INGRESS traffic, one of source_ranges, source_tags or source_service_accounts is required.
  direction     = "INGRESS" # INGRESS ! EGRESS
  # se define la VPC
  network       = google_compute_network.myvpc.id 
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-tag"]
}

# Firewall Rule: HTTP Port 80
resource "google_compute_firewall" "fw_http" {
  name = "fwrule-allow-http80"
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.myvpc.id 
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["webserver-tag"]
}