module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags
}

module "ec2" {
  source = "./modules/ec2"

  project_name         = var.project_name
  environment          = var.environment
  instance_type        = var.instance_type
  instance_count       = var.instance_count
  subnet_ids           = var.subnet_ids
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name             = var.key_name
  ami_id               = var.ami_id
  tags                 = var.tags
}

# Define CloudWatch Event Rules
module "cloudwatch" {
  source = "./modules/cloudwatch"

  project_name           = var.project_name
  environment            = var.environment
  start_cron_expression  = var.start_cron_expression
  stop_cron_expression   = var.stop_cron_expression
  start_lambda_function_name = module.lambda_start.lambda_function_name
  stop_lambda_function_name  = module.lambda_stop.lambda_function_name
  start_lambda_function_arn  = module.lambda_start.lambda_function_arn
  stop_lambda_function_arn   = module.lambda_stop.lambda_function_arn
  tags                   = var.tags

  depends_on = [module.lambda_start, module.lambda_stop]
}

# Create Lambda functions with CloudWatch Event Rule ARNs
module "lambda_start" {
  source = "./modules/lambda"

  project_name          = var.project_name
  environment           = var.environment
  function_name         = "start-ec2-instances"
  lambda_zip_path       = "${path.module}/python/start_ec2_instances.zip"
  handler               = "start_ec2_instances.lambda_handler"
  runtime               = var.lambda_runtime
  timeout               = var.lambda_timeout
  memory_size           = var.lambda_memory_size
  description           = "Lambda function to start EC2 instances during working hours"
  lambda_role_arn       = module.iam.lambda_role_arn
  cloudwatch_event_rule_arn = module.cloudwatch.start_cloudwatch_event_rule_arn
  environment_variables = {
    EC2_INSTANCE_IDS = join(",", module.ec2.instance_ids)
  }
  tags                  = var.tags
}

module "lambda_stop" {
  source = "./modules/lambda"

  project_name          = var.project_name
  environment           = var.environment
  function_name         = "stop-ec2-instances"
  lambda_zip_path       = "${path.module}/python/stop_ec2_instances.zip"
  handler               = "stop_ec2_instances.lambda_handler"
  runtime               = var.lambda_runtime
  timeout               = var.lambda_timeout
  memory_size           = var.lambda_memory_size
  description           = "Lambda function to stop EC2 instances outside working hours"
  lambda_role_arn       = module.iam.lambda_role_arn
  cloudwatch_event_rule_arn = module.cloudwatch.stop_cloudwatch_event_rule_arn
  environment_variables = {
    EC2_INSTANCE_IDS = join(",", module.ec2.instance_ids)
  }
  tags                  = var.tags
}
