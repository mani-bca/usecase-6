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
  value       = module.cloudwatch.start_cloudwatch_event_rule_arn
}

output "stop_cloudwatch_event_rule_arn" {
  description = "ARN of the CloudWatch Event rule for stopping EC2 instances"
  value       = module.cloudwatch.stop_cloudwatch_event_rule_arn
}
