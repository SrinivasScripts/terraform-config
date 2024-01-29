//outputs.tf

output "aws_iam_role_policy_attachment" {
  value = aws_iam_role_policy_attachment.ecs_task_execution_role
}

output "ecs_task_execution_role_name" {
  value = aws_iam_role.ecs_task_execution_role.arn
}
