<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudwatch_event_start"></a> [cloudwatch\_event\_start](#module\_cloudwatch\_event\_start) | git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/cloudwatch | main |
| <a name="module_cloudwatch_event_stop"></a> [cloudwatch\_event\_stop](#module\_cloudwatch\_event\_stop) | git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/cloudwatch | main |
| <a name="module_connector_start"></a> [connector\_start](#module\_connector\_start) | git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/event_lambda | main |
| <a name="module_connector_stop"></a> [connector\_stop](#module\_connector\_stop) | git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/event_lambda | main |
| <a name="module_ec2"></a> [ec2](#module\_ec2) | git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/ec2 | main |
| <a name="module_iam"></a> [iam](#module\_iam) | git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/iam | main |
| <a name="module_lambda_start"></a> [lambda\_start](#module\_lambda\_start) | git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/lambda | main |
| <a name="module_lambda_stop"></a> [lambda\_stop](#module\_lambda\_stop) | git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/lambda | main |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID for EC2 instances | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region where resources will be created | `string` | `"us-east-1"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (dev, staging, prod) | `string` | n/a | yes |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of EC2 instances to create | `number` | `1` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type | `string` | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | EC2 key pair name | `string` | `null` | no |
| <a name="input_lambda_memory_size"></a> [lambda\_memory\_size](#input\_lambda\_memory\_size) | Memory size for Lambda functions (in MB) | `number` | `128` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Runtime for Lambda functions | `string` | `"python3.9"` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | Timeout for Lambda functions (in seconds) | `number` | `30` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_start_cron_expression"></a> [start\_cron\_expression](#input\_start\_cron\_expression) | Cron expression for starting EC2 instances (default: 8:00 AM UTC Monday-Friday) | `string` | `"cron(0 8 ? * MON-FRI *)"` | no |
| <a name="input_stop_cron_expression"></a> [stop\_cron\_expression](#input\_stop\_cron\_expression) | Cron expression for stopping EC2 instances (default: 5:00 PM UTC Monday-Friday) | `string` | `"cron(0 17 ? * MON-FRI *)"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for EC2 instances | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of security group IDs for EC2 instances | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_instance_ids"></a> [ec2\_instance\_ids](#output\_ec2\_instance\_ids) | IDs of the created EC2 instances |
| <a name="output_ec2_instance_public_ips"></a> [ec2\_instance\_public\_ips](#output\_ec2\_instance\_public\_ips) | Public IPs of the created EC2 instances |
| <a name="output_start_cloudwatch_event_rule_arn"></a> [start\_cloudwatch\_event\_rule\_arn](#output\_start\_cloudwatch\_event\_rule\_arn) | ARN of the CloudWatch Event rule for starting EC2 instances |
| <a name="output_start_event_target_id"></a> [start\_event\_target\_id](#output\_start\_event\_target\_id) | ID of the CloudWatch Event target for starting EC2 instances |
| <a name="output_start_lambda_function_name"></a> [start\_lambda\_function\_name](#output\_start\_lambda\_function\_name) | Name of the Lambda function for starting EC2 instances |
| <a name="output_stop_cloudwatch_event_rule_arn"></a> [stop\_cloudwatch\_event\_rule\_arn](#output\_stop\_cloudwatch\_event\_rule\_arn) | ARN of the CloudWatch Event rule for stopping EC2 instances |
| <a name="output_stop_event_target_id"></a> [stop\_event\_target\_id](#output\_stop\_event\_target\_id) | ID of the CloudWatch Event target for stopping EC2 instances |
| <a name="output_stop_lambda_function_name"></a> [stop\_lambda\_function\_name](#output\_stop\_lambda\_function\_name) | Name of the Lambda function for stopping EC2 instances |
<!-- END_TF_DOCS -->