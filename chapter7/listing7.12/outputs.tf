output "urls" {
  value = {
    app = data.shell_script.cloud_run_url.output["url"]
    repo = google_sourcerepo_repository.repo.url
  }
}