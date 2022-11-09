#aws_db_subnet_group
resource "aws_db_subnet_group" "dbsb" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.pri13.id, aws_subnet.pri23.id]

  tags = {
    Name = "Terraform DB subnet group"
  }
}

resource "aws_db_instance" "rds" {
  allocated_storage = 10
  identifier        = "bbdb2"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"

  db_name  = "bbdb"
  username = "master"
  password = "bb-password"

  #parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true

  db_subnet_group_name   = aws_db_subnet_group.dbsb.id
  vpc_security_group_ids = [aws_security_group.db.id]

  multi_az = true
}

output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}