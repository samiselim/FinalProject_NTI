resource "aws_secretsmanager_secret" "RDS_secret" {
  name = "secret"
}

resource "aws_secretsmanager_secret_version" "example_secret_version" {
  secret_id     = aws_secretsmanager_secret.RDS_secret.id
  secret_string = jsonencode({
    username = var.RDS_username,
    password = var.RDS_password
  })
}