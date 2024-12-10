output "target_group_arn" {
  value = aws_lb_target_group.web.arn
}

output "alb_dns_name" {
  value = aws_lb.web.dns_name
}