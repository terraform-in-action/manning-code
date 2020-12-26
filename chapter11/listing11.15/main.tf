terraform {
  required_providers {
    petstore = {
      source  = "terraform-in-action/petstore"
      version = "~> 1.0"
    }
  }
}

provider "petstore" {
  address = "https://tcln1rvts1.execute-api.us-west-2.amazonaws.com/v1"
}

resource "petstore_pet" "pet" {
  name    = "snowball"
  species = "cat"
  age     = 20
}
