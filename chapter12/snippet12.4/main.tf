resource "null_resource" "uh_oh" {
  provisioner "local-exec" {
    command = <<-EOF
        echo "access_key=$AWS_ACCESS_KEY_ID"
        echo "secret_key=$AWS_SECRET_ACCESS_KEY"
    EOF
    }
}
