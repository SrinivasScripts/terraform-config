output "vpc_id" {
  value = aws_vpc.main.id
}
output "subnet_id" {
  value = aws_subnet.subnet.id
}
output "subnet_id1" {
  value = aws_subnet.subnet2.id
}
output "ecs_private_subnet_id" {
  value = aws_subnet.private_subnet1.id
}
output "ecs_private_subnet_id1" {
  value = aws_subnet.private_subnet2.id
}
