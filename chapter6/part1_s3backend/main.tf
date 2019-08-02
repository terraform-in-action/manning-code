data "aws_region" "current" {}

resource "aws_resourcegroups_group" "resourcegroups_group" {
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

resource "random_string" "rand" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_kms_key" "kms_key" {
  tags = {
    ResourceGroup = var.namespace 
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.namespace}-state-bucket-${random_string.rand.result}"

  versioning {
    enabled = true
  }
  force_destroy = var.force_destroy_state
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.kms_key.arn
      }
    }
  }
  tags = {
    ResourceGroup = var.namespace 
  }
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name         = "${var.namespace}-state-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    ResourceGroup = var.namespace 
  }
}