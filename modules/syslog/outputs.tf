output "syslog_server_ip" {
  value = aws_instance.syslog.private_ip
}
