provider "aws" {
  profile = var.aws.profile
  region  = var.aws.region
}

provider "azurerm" {
  subscription_id = var.azure.subscription_id
  client_id       = var.azure.client_id
  client_secret   = var.azure.client_secret
  tenant_id       = var.azure.tenant_id
}

provider "google" {
  credentials = file("account.json")
  project     = var.gcp.project_id
  region      = var.gcp.region
}

provider "docker" {
  host = "tcp://127.0.0.1:2375/"
}
