resource "aws_eip" "main" {
    tags = {
    Name        = local.Name
    Project     = local.Project
    Application = local.Application
    Environment = local.Environment
    Owner       = local.Owner
  }
  
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.example.id
  allocation_id = aws_eip.main.id
}
