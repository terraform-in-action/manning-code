resource "google_cloudbuild_trigger" "trigger" {
  trigger_template {
    branch_name = "master"
    repo_name   = google_sourcerepo_repository.repo.name
  }

  build {
    step {
      name = "gcr.io/cloud-builders/go"
      args = ["install", "."]
      env  = ["PROJECT_ROOT=${var.namespace}"]
    }

    step {
      name = "gcr.io/cloud-builders/go"
      args = ["install", "."]
      env  = ["PROJECT_ROOT=${var.namespace}"]
    }

    step {
      name = "gcr.io/cloud-builders/go"
      args = ["test"]
      env  = ["PROJECT_ROOT=${var.namespace}"]
    }

    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", local.image, "."]
    }

    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["push", local.image]
    }

    step {
      name = "gcr.io/cloud-builders/gcloud"
      args = ["beta", "run", "deploy", google_cloudrun_service.service.name, "--image", local.image, "--region", local.region]
    }
  }
}

value = {
  name = "gcr.io/cloud-builders/go"
  args = ["install", "."]
  env  = ["PROJECT_ROOT=${var.namespace}"]
}
locals {
  steps = [
    {
      name = "gcr.io/cloud-builders/go"
      args = ["install", "."]
      env  = ["PROJECT_ROOT=${var.namespace}"]
    },
    {
      name = "gcr.io/cloud-builders/go"
      args = ["test"]
      env  = ["PROJECT_ROOT=${var.namespace}"]
    },
    {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", local.image, "."]
    },
    {
      name = "gcr.io/cloud-builders/docker"
      args = ["push", local.image]
    },
    {
      name = "gcr.io/cloud-builders/gcloud"
      args = ["beta", "run", "deploy", google_cloudrun_service.service.name, "--image", local.image, "--region", local.region]
    }
  ]
}


dynamic "step" {
  for_each = local.steps
  content {
    name = step.value.name
    args = step.value.args
    env  = lookup(step.value, "env", null)
  }
}
