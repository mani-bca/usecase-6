# main.tf

provider "aws" {
  region = var.aws_region
}

module "iam" {
  source = "./modules/iam"

  name_prefix = var.name_prefix
  lambda_roles = {
    "start-ec2" = {
      description = "Role for Lambda function to start EC2 instances"
      additional_policy_arns = var.start_lambda_additional_policies
    },
    "stop-ec2" = {
      description = "Role for Lambda function to stop EC2 instances"
      additional_policy_arns = var.stop_lambda_additional_policies
    }
  }
  create_vpc_access_policy = length(var.lambda_subnet_ids) > 0 ? true : false
  tags                     = var.tags
}

# Create the EventBridge schedules first with dummy ARNs
module "eventbridge" {
  source = "./modules/eventbridge"

  name_prefix        = var.name_prefix
  schedule_group_name = var.schedule_group_name
  schedules = {
    "start-ec2" = {
      description        = "Schedule to start EC2 instances during working hours"
      schedule_expression = var.start_schedule_expression
      target_arn         = "arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${var.name_prefix}-start-ec2"
      role_arn           = module.iam.lambda_role_arns["start-ec2"]
    },
    "stop-ec2" = {
      description        = "Schedule to stop EC2 instances after working hours"
      schedule_expression = var.stop_schedule_expression
      target_arn         = "arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${var.name_prefix}-stop-ec2"
      role_arn           = module.iam.lambda_role_arns["stop-ec2"]
    }
  }
  tags = var.tags
}

module "lambda" {
  source = "./modules/lambda"

  name_prefix = var.name_prefix
  lambda_functions = {
    "start-ec2" = {
      filename              = "start_ec2_instances.py"
      description           = "Function to start EC2 instances during working hours"
      handler               = "start_ec2_instances.lambda_handler"
      role_arn              = module.iam.lambda_role_arns["start-ec2"]
      scheduler_arn         = module.eventbridge.schedule_arns["start-ec2"]
      environment_variables = var.start_lambda_environment_variables
    },
    "stop-ec2" = {
      filename              = "stop_ec2_instances.py"
      description           = "Function to stop EC2 instances after working hours"
      handler               = "stop_ec2_instances.lambda_handler"
      role_arn              = module.iam.lambda_role_arns["stop-ec2"]
      scheduler_arn         = module.eventbridge.schedule_arns["stop-ec2"]
      environment_variables = var.stop_lambda_environment_variables
    }
  }
  runtime             = var.lambda_runtime
  timeout             = var.lambda_timeout
  memory_size         = var.lambda_memory_size
  subnet_ids          = var.lambda_subnet_ids
  security_group_ids  = var.lambda_security_group_ids
  environment_variables = var.common_environment_variables
  log_retention_in_days = var.log_retention_in_days
  tags                 = var.tags
}

data "aws_caller_identity" "current" {}