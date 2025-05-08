# terraform.tfvars

# AWS settings
aws_region = "us-east-1"  # Change to your preferred region

# General configuration
name_prefix = "ec2-scheduler"

# Tags to add to all resources
tags = {
  Environment = "Production"
  Project     = "EC2 Cost Optimization"
  Terraform   = "true"
  Owner       = "Operations"
}

# EventBridge Scheduler settings
schedule_group_name = "ec2-scheduler-group"
start_schedule_expression = "cron(0 8 ? * MON-FRI *)"  # 8:00 AM Monday-Friday
stop_schedule_expression = "cron(0 17 ? * MON-FRI *)"  # 5:00 PM Monday-Friday

# Lambda function settings
lambda_runtime = "python3.9"
lambda_timeout = 30
lambda_memory_size = 128

# VPC configuration (optional) - leave empty arrays for no VPC deployment
lambda_subnet_ids = []
lambda_security_group_ids = []

# Lambda environment variables
common_environment_variables = {
  LOG_LEVEL = "INFO"
}

start_lambda_environment_variables = {
  TAG_KEY = "AutoStart"
  TAG_VALUE = "true"
}

stop_lambda_environment_variables = {
  TAG_KEY = "AutoStop"
  TAG_VALUE = "true"
}

# Optional additional IAM policies
start_lambda_additional_policies = []
stop_lambda_additional_policies = []

# CloudWatch Logs retention period in days
log_retention_in_days = 14