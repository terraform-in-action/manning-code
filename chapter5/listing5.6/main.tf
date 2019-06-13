#divide code into /terraform and /client
data "google_project" "project" {}

locals {
  services = ["cloudbuild.googleapis.com","run.googleapis.com","iam.googleapis.com"]
  image = "gcr.io/${local.project_id}/${var.namespace}"
  project_id = data.google_project.project.id
  steps = [
    {
      name = "gcr.io/cloud-builders/go"
      args = ["install","."]
      env = ["PROJECT_ROOT=${var.namespace}"]
    },
    {
      name = "gcr.io/cloud-builders/go"
      args = ["test"]
      env = ["PROJECT_ROOT=${var.namespace}"]
    },
    {
      name = "gcr.io/cloud-builders/docker"
      args = ["build","-t",local.image,"."]
    },
    {
      name = "gcr.io/cloud-builders/docker"
      args = ["push",local.image]
    },
    {
      name = "gcr.io/cloud-builders/gcloud"
      args = ["beta","run","deploy",google_cloudrun_service.service.name,"--image",local.image,"--region",local.region]
    }
  ]
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

resource "google_cloudbuild_trigger" "trigger" {
  trigger_template {
    branch_name = "master"
    repo_name   = google_sourcerepo_repository.repo.name
  }

  build {
    dynamic "step"{
      for_each = local.steps
      content {
        name = step.value.name
        args = step.value.args
        env = lookup(step.value,"env",null)
      }
    }
  }
}