resource "aws_vpc" "this" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  tags             = merge(var.tags, { Name = format("%s-%s-vpc", var.env, var.appname, ) })
}

resource "aws_security_group" "my-sg" {
  name   = "terraform-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_cidr_block)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_cidr_block[count.index]
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone[count.index]
  tags                    = merge(var.tags, { Name = "${var.env}" })
}

resource "aws_subnet" "private" {
  count                   = length(var.private_cidr_block)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_cidr_block[count.index]
  map_public_ip_on_launch = "false"
  availability_zone       = var.availability_zone[count.index]
  tags                    = merge(var.tags, { Name = "${var.env}-${var.env}-${var.appname}" })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.this.id
}

resource "aws_eip" "eip" {
  vpc = true
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.gw]
  tags       = merge(var.tags, { Name = format("%s-%s-%s", var.env, var.appname, "NAT") })
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = merge(var.tags, { Name = format("%s-%s-%s", "public", var.appname, var.env) })
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(var.tags, { Name = format("%s-%s-%s", "private", var.appname, var.env) })
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_cidr_block)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id

  //depends_on = [aws_nat_gateway.nat]

}