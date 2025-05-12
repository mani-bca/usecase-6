# main.tf
module "iam" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/iam?ref=main"
  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags
}

module "ec2" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/ec2?ref=main"

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

module "cloudwatch_event_start" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/cloudwatch?ref=main"

  project_name    = var.project_name
  environment     = var.environment
  rule_name       = "start-ec2-instances"
  description     = "Triggers Lambda function to start EC2 instances at specified time"
  cron_expression = var.start_cron_expression
  target_id       = "start-ec2-instances-target"
  tags            = var.tags
  lambda_function_arn = null
}

module "cloudwatch_event_stop" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/cloudwatch?ref=main"

  project_name    = var.project_name
  environment     = var.environment
  rule_name       = "stop-ec2-instances"
  description     = "Triggers Lambda function to stop EC2 instances at specified time"
  cron_expression = var.stop_cron_expression
  target_id       = "stop-ec2-instances-target"
  tags            = var.tags
  lambda_function_arn = null
}

module "lambda_start" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/lambda?ref=main"

  project_name          = var.project_name
  environment           = var.environment
  function_name         = "start-ec2-instances"
  source_file_path      = "${path.module}/../infra/python/start/start_ec2_instances.py"
  handler               = "start_ec2_instances.lambda_handler"
  runtime               = var.lambda_runtime
  timeout               = var.lambda_timeout
  memory_size           = var.lambda_memory_size
  description           = "Lambda function to start EC2 instances during working hours"
  lambda_role_arn       = module.iam.lambda_role_arn
  environment_variables = {
    EC2_INSTANCE_IDS = join(",", module.ec2.instance_ids)
  }
  tags                  = var.tags
  
  depends_on = [module.cloudwatch_event_start]
}

module "lambda_stop" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/lambda?ref=main"

  project_name          = var.project_name
  environment           = var.environment
  function_name         = "stop-ec2-instances"
  source_file_path      = "${path.module}/../infra/python/stop/stop_ec2_instances.py"
  handler               = "stop_ec2_instances.lambda_handler"
  runtime               = var.lambda_runtime
  timeout               = var.lambda_timeout
  memory_size           = var.lambda_memory_size
  description           = "Lambda function to stop EC2 instances outside working hours"
  lambda_role_arn       = module.iam.lambda_role_arn
  environment_variables = {
    EC2_INSTANCE_IDS = join(",", module.ec2.instance_ids)
  }
  tags                  = var.tags
  
  depends_on = [module.cloudwatch_event_stop]
}

module "connector_start" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/event_lambda?ref=main"
  
  cloudwatch_event_rule_arn  = module.cloudwatch_event_start.cloudwatch_event_rule_arn
  cloudwatch_event_rule_name = module.cloudwatch_event_start.cloudwatch_event_rule_name
  lambda_function_name       = module.lambda_start.lambda_function_name
  lambda_function_arn        = module.lambda_start.lambda_function_arn
  target_id                  = "start-ec2-instances-target"
  
  depends_on = [
    module.cloudwatch_event_start,
    module.lambda_start
  ]
}

module "connector_stop" {
  source = "git::https://github.com/mani-bca/set-aws-infra.git//modules/schedule2/event_lambda?ref=main"
  
  cloudwatch_event_rule_arn  = module.cloudwatch_event_stop.cloudwatch_event_rule_arn
  cloudwatch_event_rule_name = module.cloudwatch_event_stop.cloudwatch_event_rule_name
  lambda_function_name       = module.lambda_stop.lambda_function_name
  lambda_function_arn        = module.lambda_stop.lambda_function_arn
  target_id                  = "stop-ec2-instances-target"
  
  depends_on = [
    module.cloudwatch_event_stop,
    module.lambda_stop
  ]
}
