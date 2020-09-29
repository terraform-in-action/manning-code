locals {
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
  for_each = local.policy_mapping #A
  name     = each.key
  policies = each.value.policies
}
