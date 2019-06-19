variable "namespace" {
  default = "chapter5"
  type    = string
}

variable "repo_trigger" {
  default = {
    branch_name = "master",
    repo_name   = null
    create = true
  }

  type = object({
    create = bool
    branch_name = string
    repo_name   = string
  })
}
