provider "aws" {
  profile = "<profile>"
  region  = "us-west-2"
}

provider "azurerm" {
  features {}
}

provider "google" {
  project = "<project_id>"
  region  = "us-east1"
}

provider "docker" {} #A
