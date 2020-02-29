provider "google" {
  credentials = file("account.json")
  project     = var.project_id
  region      = var.region
}