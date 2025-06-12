output "alb_controller_role_arn" {
  description = "ARN of the IAM role used by the ALB controller"
  value       = aws_iam_role.aws_load_balancer_controller.arn
}
