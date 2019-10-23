data "shell_script" "cloud_run_url" {
  working_directory = path.module
  lifecycle_commands {
    read = <<EOF
sleep 10
URL=$(gcloud beta run services describe ${google_cloud_run_service.service.name} --platform managed --region ${var.region} --project ${var.project_id} --format "value(status.url)")
echo '{"url": "'"$URL"'"}' >&3
EOF
  }
}