output "vpc_id" {
  value = aws_vpc.this.id
}
output "subnets_id" {
  value = aws_subnet.public.*.id
}

output "security_groups" {
  value = aws_security_group.my-sg.id
}
