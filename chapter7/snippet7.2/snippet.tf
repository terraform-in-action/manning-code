resource "null_resource" "cowsay" {
  provisioner "local-exec" {
    command = "cowsay Hello World!"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "cowsay -d Goodbye cruel world!"
  }
}
