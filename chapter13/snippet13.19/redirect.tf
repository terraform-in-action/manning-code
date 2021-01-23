variable "password" {
  type      = string
  sensitive = true
  default   = "hunter2"
}

resource "local_file" "password" { #A
  filename = "password.txt"
  content  = var.password
}

data "local_file" "password" {
  filename = local_file.password.filename #B
}

resource "null_resource" "uh_oh" {
  provisioner "local-exec" {
    command = "echo ${data.local_file.password.content}" #C
  }
}
