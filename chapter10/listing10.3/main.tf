terraform {
  required_version = "~> 0.13"
  required_providers {
    aws   = "~> 3.6"
    local = "~> 1.4"
  }
}

provider "aws" {
    profile = "<profile>"
    region = "us-west-2"
}


resource "local_file" "credentials" { #A
  filename           = "credentials"
  file_permission    = "0644"
  sensitive_content  = <<-EOF
    [${aws_iam_user.app1.name}]
    aws_access_key_id = ${aws_iam_access_key.app1.id}
    aws_secret_access_key = ${aws_iam_access_key.app1.secret}
    
    [${aws_iam_user.app2.name}]
    aws_access_key_id = ${aws_iam_access_key.app2.id}
    aws_secret_access_key = ${aws_iam_access_key.app2.secret}
  EOF
}
