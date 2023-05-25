resource "aws_db_instance" "test_sam_tf_2" {
  allocated_storage = 5
  db_name = "test_local_3"
  engine  = "postgres"
  identifier = "sam-test-db-3"
  username = "sam"
  password = ""
  engine_version = 14.6
  instance_class = "db.t3.micro"
  publicly_accessible = true
  db_subnet_group_name = aws_db_subnet_group.test_sam_db_subnet_grp.name
  vpc_security_group_ids = [var.vpc_security_group_id]
  skip_final_snapshot = true
  final_snapshot_identifier = "testFinal"
}

resource "aws_db_subnet_group" "test_sam_db_subnet_grp" {
  name       = "test-sam-db-subnet-grp"
  subnet_ids = var.public_subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}