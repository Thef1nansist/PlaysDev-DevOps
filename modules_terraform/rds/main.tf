resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = var.private_db_subnets

  tags = {
    Name = "db_subnet_group"
  }
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "db-parameter-group"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "postgreSQL" {
  identifier             = "postgresql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.7"
  username               = "postgres"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [var.security_group_private_id]
  parameter_group_name   = aws_db_parameter_group.db_parameter_group.name
  skip_final_snapshot    = true
  multi_az               = true
}