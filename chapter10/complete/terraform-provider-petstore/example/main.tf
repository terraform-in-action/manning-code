provider "petstore" {
  address = "https://tcln1rvts1.execute-api.us-west-2.amazonaws.com/v1"
}

resource "petstore_pet" "my_pet" {
  name    = "snowball"
  species = "cat"
  age     = 8
}