variable "name" {
  type        = string
  default     = "terraform"
  description = "A project name to use for resource mapping"
}

variable "auto_apply" {
  type        = bool
  default     = false
  description = "Whether to automatically apply changes when a Terraform plan is successful. Defaults to false."
}

variable "terraform_version" {
  type        = string
  default     = "latest"
  description = "The version of Terraform to use for this workspace. Defaults to the latest available version."
}

variable "working_directory" {
  type        = string
  default     = "."
  description = "A relative path that Terraform will execute within. Defaults to the root of your repository."
}

variable "vcs_repo" {
  type        = object({ identifier = string, branch = string, oauth_token = string })
  description = "Settings for the workspace's VCS repository."
}

variable "environment" {
  type        = map(string)
  default     = {}
  description = "A map of environment varaibles to use for this workspace"
}

variable "s3_backend_config" {
  type = object({
    bucket         = string,
    region         = string,
    role_arn       = string,
    dynamodb_table = string,
  })
  description = "Settings for configuring the S3 remote backend"
}
