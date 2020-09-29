locals {
  policies = {
    for path in fileset(path.module, "policies/*.json") : basename(path) => file(path)
  }
  policy_mapping = {
    "app1" = {
      policies = [local.policies["app1.json"]],
    },
    "app2" = {
      policies = [local.policies["app2.json"]],
    },
  }
}

module "iam" {
  source   = "./modules/iam"
  for_each = local.policy_mapping
  name     = each.key
  policies = each.value.policies
}
