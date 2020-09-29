resource "aws_iam_user" "app2" {
  name          = "app2-svc-account"
  force_destroy = true
}

resource "aws_iam_user_policy" "app2" {
  user   = aws_iam_user.app1.name
  policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "s3:List*"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
      ]
    }
  EOF
}

resource "aws_iam_access_key" "app2" {
  user = aws_iam_user.app2.name
}
