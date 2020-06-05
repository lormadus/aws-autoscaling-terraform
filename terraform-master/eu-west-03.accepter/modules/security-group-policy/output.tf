output "alb_sgs" {
  value       = aws_security_group.alb
}

output "web_server_sgs" {
  value       = aws_security_group.web_server
}

output "ssh_sgi" {
  value       = aws_security_group.ssh_maintenance.id
}