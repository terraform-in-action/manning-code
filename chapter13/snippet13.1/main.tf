resource "aws_db_instance" "database" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "9.5"
  instance_class       = "db.t3.medium"
  name                 = "ptfe"
  username             = var.username
  password             = var.password
}
