resource "aws_db_subnet_group" "db_subnets" {
  name       = "fp_db_subnet_group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "fp_RDS_subnet_group"
  }
}

resource "aws_db_instance" "fp_RDS" {
  db_name = "mydatabase"
  allocated_storage    = var.RDS_cfg["allocated_storage"][0]
  storage_type         = var.RDS_cfg["storage_type"][0]
  engine               = var.RDS_cfg["engine"][0]
  engine_version       = var.RDS_cfg["engine_version"][0]
  instance_class       = var.RDS_cfg["instance_class"][0]
  username             = var.RDS_cfg["username"][0]
  password             = var.RDS_cfg["password"][0]
  db_subnet_group_name = aws_db_subnet_group.db_subnets.name
#   parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = var.db_sg_ids
  publicly_accessible  = true
  skip_final_snapshot = true
  tags = {
    Name = "fp-db"
  }
}