resource "aws_s3_bucket_object" "aws" {
  key     = "creds.txt"
  bucket  = var.bucket_name
  content = <<-EOF
  access_key = ${var.access_key}
  secret_key = ${var.secret_key}
  EOF
}
