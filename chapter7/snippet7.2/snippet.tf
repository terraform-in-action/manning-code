resource "null_resource" "cowsay" {
  provisioner "local-exec" { #A
    command = "cowsay Hello World!"
  }
  provisioner "local-exec" { #B
    when    = destroy
    command = "cowsay -d Goodbye cruel world!"
  }
}
