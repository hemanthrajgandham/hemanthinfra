resource "aws_security_group" "rds_sg" {
  name        = "${var.prefix}-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "main" {
    identifier = "${var.prefix}-rds-instance"
  allocated_storage    = 20
  db_name              = "pharmadb"
      engine               = "postgres"
  engine_version       = "15.7"
  instance_class       = var.instance_class
  username             =  var.db_username
  manage_master_user_password = true
  parameter_group_name = "default.postgres15"
  skip_final_snapshot  = true
  db_subnet_group_name = var.rds_subnet_group_name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-rds-instance"
    }
  )
}