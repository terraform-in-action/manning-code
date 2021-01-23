resource "aws_s3_bucket" "codepipeline" {
  bucket        = "${local.namespace}-codepipeline"
  acl           = "private"
  force_destroy = true
}

resource "aws_sns_topic" "codepipeline" {
  name = "${local.namespace}-codepipeline"
}

resource "aws_codestarconnections_connection" "github" {
  name          = "${local.namespace}-github"
  provider_type = "GitHub"
}
