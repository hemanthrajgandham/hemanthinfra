output "master_password_arn" {
  value = aws_db_instance.main.master_user_secret[0].secret_arn
  }