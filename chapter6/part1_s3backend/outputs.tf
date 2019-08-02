output "config" {
    value = {
      bucket = aws_s3_bucket.s3_bucket.bucket
      region = data.aws_region.current.name
      role_arn = aws_iam_role.iam_role.arn
    }
}