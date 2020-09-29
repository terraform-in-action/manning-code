provider "aws" {
    region = "us-west-2"
}

variable "bucket_name" {
    type = string
}

resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
  acl = "public-read"
  policy = <<-EOF
    {
      "Version": "2008-10-17",
      "Statement": [
        {
          "Sid": "PublicReadForGetBucketObjects",
          "Effect": "Allow",
          "Principal": {
            "AWS": "*"
          },
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        }
      ]
    }
  EOF

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.website.bucket
  key    = "index.html"
  source = "index.html"
  etag = filemd5("${path.module}/index.html")
  content_type = "text/html"
}

output "endpoint" {
  value = aws_s3_bucket.website.website_endpoint
}
