variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

# EC2 Variables
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "List of subnet IDs for EC2 instances"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs for EC2 instances"
  type        = list(string)
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = null
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

# Lambda Variables
variable "lambda_runtime" {
  description = "Runtime for Lambda functions"
  type        = string
  default     = "python3.9"
}

variable "lambda_timeout" {
  description = "Timeout for Lambda functions (in seconds)"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Memory size for Lambda functions (in MB)"
  type        = number
  default     = 128
}

# CloudWatch Event Variables
variable "start_cron_expression" {
  description = "Cron expression for starting EC2 instances (default: 8:00 AM UTC Monday-Friday)"
  type        = string
  default     = "cron(0 8 ? * MON-FRI *)"
}

variable "stop_cron_expression" {
  description = "Cron expression for stopping EC2 instances (default: 5:00 PM UTC Monday-Friday)"
  type        = string
  default     = "cron(0 17 ? * MON-FRI *)"
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
