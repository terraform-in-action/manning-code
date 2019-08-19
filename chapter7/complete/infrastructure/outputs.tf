output "urls" {
  value = {
    app = data.shell_script.cloudrun_url.output["url"]
    repo = google_sourcerepo_repository.repo.url
  }
}