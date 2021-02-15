terraform {
  backend "s3" {
    bucket         = "team-rocket-1qh28hgo0g1c-state-bucket"
    key            = "jesse/james"
    region         = "us-west-2"
    encrypt        = true
    profile        = "swinkler" # this should be changed.
    role_arn       = "arn:aws:iam::215974853022:role/team-rocket-1qh28hgo0g1c-tf-assume-role"
    dynamodb_table = "team-rocket-1qh28hgo0g1c-state-lock"
  }
  required_version = ">= 0.15"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

resource "null_resource" "motto" {
  triggers = {
    always = timestamp()
  }
  provisioner "local-exec" {
    command = "echo gotta catch em all" #A
  }
}
