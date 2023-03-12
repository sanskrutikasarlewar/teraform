output "public_subnets_ids" {
  value = aws_subnet.public.*.id
}

output "security_groups" {
  value = aws_security_group.my-sg.id
}
