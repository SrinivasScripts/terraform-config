# outputs.tf

output "alb_hostname" {
  value = aws_alb.main.dns_name
}
output "alb_tg" {
  value = aws_alb_target_group.app.id
}
output "alb_listner" {
  value = aws_alb_listener.app_listner
}
