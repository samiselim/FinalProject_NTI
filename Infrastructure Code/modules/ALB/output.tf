output "ALB_DNS" {
  value = aws_lb.load_balancer[*].dns_name
}