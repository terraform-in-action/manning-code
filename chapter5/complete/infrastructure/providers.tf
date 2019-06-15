provider "google-beta" {
  credentials = "${file("account.json")}"
  project     = var.project_id
  region      = var.gcp_region
}

provider "google" {
  credentials = "${file("account.json")}"
  project     = var.project_id
  region      = var.gcp_region
}