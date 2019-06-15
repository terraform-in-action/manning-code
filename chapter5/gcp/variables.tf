variable "project_id" {
    default = "terraform-in-action"
    description = "The GCP project id"
    type = string
}

variable "namespace" {
    default = "chapter5"
    description = "The project namespace to use for unique resource naming"
    type = string
}

variable "gcp_region" {
    default = "us-central1"
    description = "GCP region"
    type = string
}