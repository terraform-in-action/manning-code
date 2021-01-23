variable "password" {
  type      = string
  sensitive = true
  default   = "hunter2"
}

resource "null_resource" "safe" {
  provisioner "local-exec" {
    command = "echo ${var.password}"
  }
}
