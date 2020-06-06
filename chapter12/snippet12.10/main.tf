resource "local_file" "aws" {
  filename = "credentials.txt"
  content = <<-EOF
  access_key = ${var.access_key}
  secret_key = ${var.secret_key}
  EOF
}
