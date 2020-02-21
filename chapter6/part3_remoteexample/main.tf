terraform {
  backend "s3" {
    bucket   = "pokemon-state-bucket-w52hjupq"
    key      = "pikachu/thunderbolt"
    region   = "us-west-2"
    encrypt  = true
    profile  = "swinkler"
    role_arn = "arn:aws:iam::215974853022:role/tf-assume-role"
  }
  required_version = "~> 0.12"
  required_providers {
    null = "~> 2.1"
  }
}

resource "null_resource" "motto" {
  triggers = {
    always = timestamp()
  }
  provisioner "local-exec" {
    command = "echo gotta catch em all"
  }
}
