aws_region     = "us-east-1"
project_name   = "ec2-scheduler"
environment    = "dev"

# EC2 Configuration
instance_type  = "t2.micro"
instance_count = 1
subnet_ids     = ["subnet-12345678"]
vpc_security_group_ids = ["sg-12345678"]
key_name       = "my-key-pair"
ami_id         = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI (replace with appropriate AMI)

# Lambda Configuration
lambda_runtime     = "python3.9"
lambda_timeout     = 30
lambda_memory_size = 128

# CloudWatch Event Configuration
start_cron_expression = "cron(0 8 ? * MON-FRI *)"  # 8:00 AM UTC Monday-Friday
stop_cron_expression  = "cron(0 17 ? * MON-FRI *)" # 5:00 PM UTC Monday-Friday

# Tags
tags = {
  Project     = "EC2 Instance Scheduler"
  Owner       = "DevOps Team"
  Environment = "dev"
}
