output "db_id" {
  value = aws_db_instance.fp_RDS.id
}
output "db_username" {
  value = aws_db_instance.fp_RDS.username
}
output "db_endpoint" {
  value = aws_db_instance.fp_RDS.endpoint
}