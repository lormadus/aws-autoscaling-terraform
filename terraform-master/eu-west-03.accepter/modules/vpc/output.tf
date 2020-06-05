output "id" {
    value       = aws_vpc.vpc.id
}

output "frontend_subnets" {
    value       = aws_subnet.frontend
}

# ENABLE_BACKEND_SUBNET = false이면 주석처리
output "backend_subnets" {
    value       = aws_subnet.backend
}