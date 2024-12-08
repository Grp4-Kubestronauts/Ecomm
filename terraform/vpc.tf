# Primary Region VPC (existing code)
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                              = "${var.environment}-private-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.environment}-public-${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

# NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.environment}-nat"
  }
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.environment}-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.environment}-private"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Secondary Region (DR) VPC
data "aws_availability_zones" "dr_available" {
  provider = aws.secondary
  state    = "available"
}

resource "aws_vpc" "dr" {
  provider             = aws.secondary
  cidr_block           = var.vpc_cidr_secondary # Ensure this CIDR block doesn't overlap with primary region
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.environment}-dr-vpc"
  }
}

resource "aws_subnet" "dr_private" {
  count             = 2
  provider          = aws.secondary
  vpc_id            = aws_vpc.dr.id
  cidr_block        = cidrsubnet(var.vpc_cidr_secondary, 8, count.index)
  availability_zone = data.aws_availability_zones.dr_available.names[count.index]

  tags = {
    Name                              = "${var.environment}-dr-private-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "dr_public" {
  count             = 2
  provider          = aws.secondary
  vpc_id            = aws_vpc.dr.id
  cidr_block        = cidrsubnet(var.vpc_cidr_secondary, 8, count.index + 2)
  availability_zone = data.aws_availability_zones.dr_available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.environment}-dr-public-${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
  }
}

# DR Internet Gateway
resource "aws_internet_gateway" "dr" {
  provider = aws.secondary
  vpc_id   = aws_vpc.dr.id

  tags = {
    Name = "${var.environment}-dr-igw"
  }
}

# DR NAT Gateway
resource "aws_eip" "dr_nat" {
  provider = aws.secondary
  domain   = "vpc"
}

resource "aws_nat_gateway" "dr" {
  provider      = aws.secondary
  allocation_id = aws_eip.dr_nat.id
  subnet_id     = aws_subnet.dr_public[0].id

  tags = {
    Name = "${var.environment}-dr-nat"
  }
}

# DR Route Tables
resource "aws_route_table" "dr_public" {
  provider = aws.secondary
  vpc_id   = aws_vpc.dr.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dr.id
  }

  tags = {
    Name = "${var.environment}-dr-public"
  }
}

resource "aws_route_table" "dr_private" {
  provider = aws.secondary
  vpc_id   = aws_vpc.dr.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dr.id
  }

  tags = {
    Name = "${var.environment}-dr-private"
  }
}

resource "aws_route_table_association" "dr_public" {
  provider       = aws.secondary
  count          = 2
  subnet_id      = aws_subnet.dr_public[count.index].id
  route_table_id = aws_route_table.dr_public.id
}

resource "aws_route_table_association" "dr_private" {
  provider       = aws.secondary
  count          = 2
  subnet_id      = aws_subnet.dr_private[count.index].id
  route_table_id = aws_route_table.dr_private.id
}
