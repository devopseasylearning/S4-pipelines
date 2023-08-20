




# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = local.Name
    Project     = local.Project
    Application = local.Application
    Environment = local.Environment
    Owner       = local.Owner
  }
  
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name        = local.Name
    Project     = local.Project
    Application = local.Application
    Environment = local.Environment
    Owner       = local.Owner
  }
  
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = local.Name
    Project     = local.Project
    Application = local.Application
    Environment = local.Environment
    Owner       = local.Owner
  }
  
}

# Create a route table for the public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name        = local.Name
    Project     = local.Project
    Application = local.Application
    Environment = local.Environment
    Owner       = local.Owner
  }
  
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a security group
resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.main_vpc.id

  # This is an example rule that allows all inbound traffic.
  # You should adjust this to your security requirements.
  ingress {
    from_port   = 0
    to_port     = 65535
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
    Name        = local.Name
    Project     = local.Project
    Application = local.Application
    Environment = local.Environment
    Owner       = local.Owner
  }
  
}
