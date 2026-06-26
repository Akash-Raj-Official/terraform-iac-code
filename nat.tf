# Elastic IP for NAT Gateway (NAT needs a static public IP)
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "NAT-EIP"
  }
}

# NAT Gateway - lives in the PUBLIC subnet so it can reach the internet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id # Must be in public subnet

  tags = {
    Name = "NAT-Gateway"
  }

  # NAT Gateway depends on the Internet Gateway being ready first
  depends_on = [aws_internet_gateway.gw]
}
