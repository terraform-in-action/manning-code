data "aws_secretsmanager_secret_version" "db" {
  secret_id = var.secret_id
}

locals {
  creds = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
}

resource "aws_db_instance" "database" {
  allocated_storage = 20
  engine            = "postgres"
  engine_version    = "12.2"
  instance_class    = "db.t2.micro"
  name              = "ptfe"
  username          = local.creds["username"]
  password          = local.creds["password"]
}
