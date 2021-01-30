locals {
  services = [ #A
    "sourcerepo.googleapis.com",
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "iam.googleapis.com",
  ]
}

resource "google_project_service" "enabled_service" {
  for_each = toset(local.services)
  project  = var.project_id
  service  = each.key

  provisioner "local-exec" { #B
    command = "sleep 60"
  }

  provisioner "local-exec" { #C
    when    = destroy
    command = "sleep 15"
  }
}
