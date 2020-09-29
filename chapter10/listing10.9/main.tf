variable "name" {
  type = string
}

variable "policies" {
  type = list(string)
}

resource "aws_iam_user" "user" {
  name          = "${var.name}-svc-account"
  force_destroy = true
}

resource "aws_iam_policy" "policy" { #A
  count  = length(var.policies)
  name        = "${var.name}-policy-${count.index}"
  policy      = var.policies[count.index]
}

resource "aws_iam_user_policy_attachment" "attachment" {
    count  = length(var.policies)
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.policy[count.index].arn
}

resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.user.name
}

output "credentials" { #B
  value = <<-EOF
    [${aws_iam_user.user.name}]
    aws_access_key_id = ${aws_iam_access_key.access_key.id}
    aws_secret_access_key = ${aws_iam_access_key.access_key.secret}
  EOF
}
