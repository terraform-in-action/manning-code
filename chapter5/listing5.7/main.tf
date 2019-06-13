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