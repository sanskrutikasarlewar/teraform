resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = {
    Name = var.appname
  }
}

resource "aws_subnet" "public" {
    count = length(var.public_cidr_block)
    vpc_id = aws_vpc.this.id
    cidr_block = var.public_cidr_block[count.index]
    map_public_ip_on_launch = "true"
    availability_zone = var.availability_zone[count.index]
    tags = merge(var.tags, {Name = "${var.env}"})
}

resource "aws_subnet" "private"{
    count = length(var.private_cidr_block)
    vpc_id = aws_vpc.this.id
    cidr_block = var.private_cidr_block[count.index]
    map_public_ip_on_launch = "false"
    availability_zone = var.availability_zone[count.index]
    tags = merge(var.tags, {Name = "${var.env}-${var.env}-${var.appname}"})
}
