resource "local_file" "credentials" {
  filename           = "credentials"
  file_permission    = "0644"
  sensitive_content  = <<-EOF
    [${aws_iam_user.app1.name}] #A
    aws_access_key_id = ${aws_iam_access_key.app1.id} #A
    aws_secret_access_key = ${aws_iam_access_key.app1.secret} #A
    
    [${aws_iam_user.app2.name}] #B
    aws_access_key_id = ${aws_iam_access_key.app2.id} #B
    aws_secret_access_key = ${aws_iam_access_key.app2.secret} #B
  EOF
}
