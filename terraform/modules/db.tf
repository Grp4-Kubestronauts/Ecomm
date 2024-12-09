

# 1. Create a Security Group for the Database
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow inbound traffic to the database from EC2 instances"
  vpc_id      = aws_vpc.main.id  # Make sure the VPC exists or create it if needed


  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow access from anywhere (use more restrictive CIDR if needed)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db_sg"
  }
}


resource "aws_db_instance" "primary" {
  identifier              = "mydb2"
  engine                  = "postgres"
  engine_version          = "16.3"
  instance_class          = "db.t3.micro"  # Free Tier eligible
  allocated_storage       = 20
  db_name                 = "ecomm"
  username                = "postgres"
  password                = "admin12345"  # Use a secure method for handling passwords
  port                    = 5432
  publicly_accessible     = true
  vpc_security_group_ids  = [aws_security_group.db_sg.id]  # Reference the security group here
  
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
  
  backup_retention_period = 7
  multi_az                = false
  storage_encrypted       = true
  backup_window         = "03:00-04:00"
  maintenance_window    = "Mon:04:00-Mon:05:00"
  auto_minor_version_upgrade = true
  tags = {
    Environment = "production"
    Name        = "mydb2-postgresql"
  }

  storage_type            = "gp2"
}


# Create a DB subnet group for RDS to use the subnets
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.db_public_subnet.id, aws_subnet.db_private_subnet.id]

  tags = {
    Name = "my-db-subnet-group"
  }
}



