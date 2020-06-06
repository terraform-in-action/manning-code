provider "vault" {
  address = var.vault_address
}

data "vault_aws_access_credentials" "creds" {
  backend = "aws"
  role    = "prod-role"
}

provider "aws" {
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
  region     = "us-west-2"
}