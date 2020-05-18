resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "${local.namespace}-codepipeline-bucket"
  acl           = "private"
  force_destroy = true
}

resource "aws_sns_topic" "codepipeline" {
  name = "${local.namespace}-pipeline-topic"
}
