output "rds_hostname" {
  value       = aws_db_instance.private_rds_instance.address
}
output "rds_port" {
  value       = aws_db_instance.private_rds_instance.port
}
output "rds_username" {
  value       = aws_db_instance.private_rds_instance.username
}