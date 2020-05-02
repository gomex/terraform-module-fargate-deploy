resource "aws_cloudwatch_log_group" "monit" {
  name              = var.cloudwatch_group_name
  retention_in_days = "14"

  tags = {
    Environment = var.environment
    Application = var.app_name
  }
}