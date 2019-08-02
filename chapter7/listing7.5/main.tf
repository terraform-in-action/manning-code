data "google_project" "project" {}

locals {
  services = ["cloudbuild.googleapis.com","run.googleapis.com","iam.googleapis.com"]
  image = "gcr.io/${local.project_id}/${var.namespace}"
  roles = ["roles/run.admin","roles/iam.serviceAccountUser"]
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

resource "google_sourcerepo_repository" "repo" {
  depends_on = [google_project_service.enabled_service]
  name = "${var.namespace}-repo"
}