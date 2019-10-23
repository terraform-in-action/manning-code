resource "null_resource" "cloud_run_allow" {
  provisioner "local-exec" {
    command = <<EOF
cd ${path.module}
gcloud beta run services set-iam-policy ${google_cloud_run_service.service.name} --region ${var.region} policy.yaml -q --project ${var.project_id}
EOF
  }
}