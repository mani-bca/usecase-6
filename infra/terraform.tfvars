aws_region     = "us-east-1"
project_name   = "ec2-scheduler"
environment    = "dev"

# EC2 Configuration
instance_type  = "t2.micro"
instance_count = 1
subnet_ids     = ["subnet-0aade558b97319d86"]
vpc_security_group_ids = ["sg-09a1e6e668e0e62df"]
key_name       = "devops"
ami_id         = "ami-084568db4383264d4"

# Lambda Configuration
lambda_runtime     = "python3.9"
lambda_timeout     = 30
lambda_memory_size = 128

# CloudWatch Event Configuration
start_cron_expression = "cron(0/10 * ? * * *)" 
stop_cron_expression  = "cron(0 17 ? * MON-FRI *)"

tags = {
  Project     = "EC2 Instance Scheduler"
  Owner       = "DevOps Team"
  Environment = "dev"
}
