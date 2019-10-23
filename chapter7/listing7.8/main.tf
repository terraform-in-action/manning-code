resource "google_cloud_run_service" "service" {
  depends_on = [
    google_project_service.enabled_service["cloudrun.googleapis.com"]
  ]

  provider = "google-beta"
  location = var.region
  name     = var.namespace
  metadata {
    namespace = var.project_id
  }
  spec {
    containers {
      image = "${local.image}:latest"
    }
  }
}