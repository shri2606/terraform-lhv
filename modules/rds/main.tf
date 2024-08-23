resource "aws_db_subnet_group" "main" {
  name       = "dev-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.environment}-db-subnet-group"
  }
}


resource "aws_db_instance" "main" {
  identifier           = "dev-db-instance"
  engine               = "Postgres"
  engine_version       = "16.4"
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  storage_encrypted    = true
  multi_az             = var.multi_az
  db_name              = "lighthousedb"
  username             = "postgres"
  password             = "admin123"
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = var.security_group_ids
  
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  skip_final_snapshot = true
  apply_immediately   = true

  tags = {
    Name = "${var.environment}-db-instance"
  }
}

resource "aws_db_parameter_group" "main" {
  family = "postgres12"
  name   = "${var.environment}-db-param-group"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }
}