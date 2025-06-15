data "aws_subnets" "subnet_ids" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = data.aws_subnets.subnet_ids
}

resource "aws_db_instance" "my_database" {
  engine               = "mysql"
  username             = var.db_username
  password             = var.db_password
  port                 = "3306"
  allocated_storage    = 10
  instance_class       = "db.t3.micro"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
}
