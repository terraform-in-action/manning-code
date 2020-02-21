variable "name" {
  type = string
}

variable "policy" {
  type = string
}

resource "aws_iam_user" "svc_account" {
  name          = var.name
  force_destroy = true
}

resource "aws_iam_user_policy" "svc_account" {
  user   = aws_iam_user.svc_account.name
  policy = var.policy
}

resource "aws_iam_access_key" "svc_account" {
  user = aws_iam_user.svc_account.name
}

output "credentials" {
  value = <<-EOF
    [${aws_iam_user.svc_account.name}]
    aws_access_key_id = ${aws_iam_access_key.svc_account.id}
    aws_secret_access_key = ${aws_iam_access_key.svc_account.secret}
  EOF
}
