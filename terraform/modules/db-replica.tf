# Create a subnet group in the DR region
resource "aws_db_subnet_group" "dr_subnet_group" {
  provider    = aws.secondary
  name        = "dr-db-subnet-group"
  subnet_ids  = [aws_subnet.dr_private[0].id, aws_subnet.dr_private[1].id]
  
  tags = {
    Name = "dr-db-subnet-group"
  }
}

# Create a security group for the replica
resource "aws_security_group" "db_sg_dr" {
  provider    = aws.secondary
  name        = "db_sg_dr"
  description = "Security group for DR database replica"
  vpc_id      = aws_vpc.dr.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db_sg_dr"
  }
}

# Create KMS key in secondary region for encryption
resource "aws_kms_key" "replica_encryption_key" {
  provider                = aws.secondary
  description            = "KMS key for RDS replica encryption"
  deletion_window_in_days = 7
  enable_key_rotation    = true

  tags = {
    Name = "rds-replica-key"
  }
}

resource "aws_kms_alias" "replica_key_alias" {
  provider      = aws.secondary
  name          = "alias/rds-replica-key"
  target_key_id = aws_kms_key.replica_encryption_key.key_id
}

# Create the read replica with encryption configuration
resource "aws_db_instance" "replica" {
  provider                = aws.secondary
  identifier             = "mydb2-replica"
  replicate_source_db    = aws_db_instance.primary.arn
  instance_class         = "db.t3.micro"
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.db_sg_dr.id]
  db_subnet_group_name   = aws_db_subnet_group.dr_subnet_group.name
  
  # Encryption configuration
  storage_encrypted     = true
  kms_key_id           = aws_kms_key.replica_encryption_key.arn
  
  auto_minor_version_upgrade = true
  multi_az                   = false

  tags = {
    Name        = "mydb2-replica"
    Environment = "dr"
  }
}

# Output the replica endpoint
output "replica_endpoint" {
  value = aws_db_instance.replica.endpoint
}