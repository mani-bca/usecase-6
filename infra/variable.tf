# variables.tf

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix to be used for all resources"
  type        = string
  default     = "ec2-scheduler"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

# EventBridge Scheduler variables
variable "schedule_group_name" {
  description = "Name of the EventBridge Scheduler schedule group"
  type        = string
  default     = "ec2-scheduler-group"
}

variable "start_schedule_expression" {
  description = "Cron expression for when to start EC2 instances"
  type        = string
  default     = "cron(0 8 ? * MON-FRI *)" # 8:00 AM Monday-Friday
}

variable "stop_schedule_expression" {
  description = "Cron expression for when to stop EC2 instances"
  type        = string
  default     = "cron(0 17 ? * MON-FRI *)" # 5:00 PM Monday-Friday
}

# Lambda variables
variable "lambda_runtime" {
  description = "Runtime for Lambda functions"
  type        = string
  default     = "python3.9"
}

variable "lambda_timeout" {
  description = "Timeout for Lambda functions in seconds"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Memory size for Lambda functions in MB"
  type        = number
  default     = 128
}

variable "lambda_subnet_ids" {
  description = "List of subnet