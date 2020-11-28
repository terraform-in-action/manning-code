output "db_config" {
  value = {
    user     = aws_db_instance.database.username #A
    password = aws_db_instance.database.password #A
    database = aws_db_instance.database.name #A
    hostname = aws_db_instance.database.address #A
    port     = aws_db_instance.database.port #A
  }
}
