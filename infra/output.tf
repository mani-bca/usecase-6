# outputs.tf

output "ec2_instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = module.ec2.instance_ids
}

output "ec2_instance_public_ips" {
  description = "Public IPs of the created EC2 instances"
  value       = module.ec2.instance_public_ips
}

output "start_lambda_function_name" {
  description = "Name of the Lambda function for starting EC2 instances"
  value       = module.lambda_start.lambda_function_name
}

output "stop_lambda_function_name" {
  description = "Name of the Lambda function for stopping EC2 instances"
  value       = module.lambda_stop.lambda_function_name
}

output "start_cloudwatch_event_rule_arn" {
  description = "ARN of the CloudWatch Event rule for starting EC2 instances"
  value       = module.cloudwatch_event_start.cloudwatch_event_rule_arn
}

output "stop_cloudwatch_event_rule_arn" {
  description = "ARN of the CloudWatch Event rule for stopping EC2 instances"
  value       = module.cloudwatch_event_stop.cloudwatch_event_rule_arn
}

output "start_event_target_id" {
  description = "ID of the CloudWatch Event target for starting EC2 instances"
  value       = module.connector_start.event_target_id
}

output "stop_event_target_id" {
  description = "ID of the CloudWatch Event target for stopping EC2 instances"
  value       = module.connector_stop.event_target_id
}