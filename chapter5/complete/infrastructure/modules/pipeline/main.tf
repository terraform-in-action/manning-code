#divide code into /terraform and /client
data "google_project" "project" {}

locals {
  services = ["cloudbuild.googleapis.com","run.googleapis.com","iam.googleapis.com"]
  image = "gcr.io/${local.project_id}/${var.namespace}"
  roles = ["roles/run.admin","roles/iam.serviceAccountUser"]
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

resource "google_project_iam_member" "cloudbuild_roles" {
  depends_on = [google_cloudbuild_trigger.trigger]
  count = length(local.roles)
  project = local.project_id
  role    = local.roles[count.index]
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_cloudrun_service" "service" {
    depends_on = [google_project_service.enabled_service]
    provider = "google-beta"
    location = local.region
    name = "${var.namespace}-service"
    metadata {
        namespace = local.project_id
    }
    spec  {
        container  {
            image = "${local.image}:latest"       
        }
    }
}

resource "null_resource" "cloudrun_allow" {
    provisioner "local-exec" {
        command = "gcloud beta run services set-iam-policy ${google_cloudrun_service.service.name} --region us-central1 policy.yaml -q"
    }
}