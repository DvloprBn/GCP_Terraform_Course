# create IAM Service Account
# Allows management of a Google Cloud service account.
# If you delete and recreate a service account, you must reapply any IAM roles that it had before.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "gke_sa" {
  account_id   = "${local.name}-gke-sa"
  display_name = "${local.name} GKE Service Account"
}