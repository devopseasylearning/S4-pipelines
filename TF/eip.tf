resource "aws_eip" "main" {
  tags = {
    "Name" = "s4-session-eip"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.example.id
  allocation_id = aws_eip.main.id
}
