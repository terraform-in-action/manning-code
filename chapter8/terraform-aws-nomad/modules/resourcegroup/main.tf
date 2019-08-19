data "aws_region" "current" {}

resource "aws_resourcegroups_group" "test" {
  name = "${var.namespace}-group"

  resource_query {
    query = <<-JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "ResourceGroup",
      "Values": ["${var.namespace}"]
    }
  ]
}
  JSON
  }
}