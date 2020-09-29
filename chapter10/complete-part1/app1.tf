resource "aws_iam_user" "app1" {
  name          = "app1-svc-account"
  force_destroy = true
}

resource "aws_iam_user_policy" "app1" {
  user   = aws_iam_user.app1.name
  policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "ec2:Describe*"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
      ]
    }
  EOF
}

resource "aws_iam_access_key" "app1" {
  user = aws_iam_user.app1.name
}
