terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "fightclub"
    token = "wxxx"
    workspaces {
      name = "my-app-dev"
    }
  }
}

resource "null_resource" "yolo" {
  triggers = {
    always = timestamp()
  }
  provisioner "local-exec" {
    command = "echo yolo"
  }
}
