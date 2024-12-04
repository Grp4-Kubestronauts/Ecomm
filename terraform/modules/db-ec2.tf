# 3. Create Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow inbound traffic to EC2 instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22  # Allow SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80  # Allow HTTP
    to_port     = 80
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
    Name = "db-ec2-sg"
  }
}

# 4. Create the EC2 Instance
resource "aws_instance" "db-server" {
  ami             = "ami-0c80e2b6ccb9ad6d1"  # Amazon Linux 2023 AMI ID
  instance_type   = "t2.micro"               # Free tier eligible
  key_name        = "bosco_winmachine"          # Use your key pair name here
  subnet_id       = aws_subnet.db_public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  # User data script to install PostgreSQL and run updates
  user_data = <<-EOF
              #!/bin/bash
              sudo dnf update -y
              sudo dnf install postgresql15.x86_64 postgresql15-server -y
              psql --version

              touch init.sql
              EOF

  tags = {
    Name = "database-server"
  }

  # Optional: To use spot instances for cost saving
  # spot_price = "0.005"  # Set spot price if necessary

  # Enable monitoring (optional)
  monitoring = true
}

# 5. Allocate Elastic IP for the EC2 instance (optional)
resource "aws_eip" "public_ip" {
  instance = aws_instance.db-server.id
}
