resource "google_project_service" "enabled_service" {
  for_each = toset(local.services)
  project  = var.project_id
  service = each.key

  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sleep 15"
  }
}