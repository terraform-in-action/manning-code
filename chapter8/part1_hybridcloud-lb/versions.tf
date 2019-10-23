terraform {
  required_version = "~> 0.12"
  required_providers {
    aws     = "~> 2.29"
    azurerm = "~> 1.34"
    google  = "~> 2.16"
    random  = "~> 2.2"
    docker  = "~> 2.3"
  }
}
