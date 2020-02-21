module "app1" {
  source = "./modules/iam_user"
  name   = "app1-service-account"
  policy = file("./policies/app1.json")
}

module "app2" {
  source = "./modules/iam_user"
  name   = "app2-service-account"
  policy = file("./policies/app2.json")
}

locals {
  credentials = [
    module.app1.credentials,
    module.app2.credentials,
  ]
}

resource "local_file" "credentials" {
  filename = "credentials"
  content  = join("\n", local.credentials)
}