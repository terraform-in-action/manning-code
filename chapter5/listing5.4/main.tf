data "google_project" "project" {}

locals {
  services = ["cloudbuild.googleapis.com","run.googleapis.com","iam.googleapis.com"]
  project_id = data.google_project.project.id
}

resource "google_project_service" "enabled_service" {
  count = length(local.services)
  project = local.project_id
  service = local.services[count.index]
  provisioner "local-exec" {
    command = "sleep 60"
  }
}