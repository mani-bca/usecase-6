import boto3
import os
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Lambda function to stop EC2 instances based on a provided list of instance IDs.
    The instance IDs are passed through an environment variable EC2_INSTANCE_IDS
    as a comma-separated string.
    """
    # Get EC2 instance IDs from environment variable
    instance_ids_str = os.environ.get('EC2_INSTANCE_IDS', '')
    
    if not instance_ids_str:
        logger.warning("No EC2 instance IDs provided. Nothing to stop.")
        return {
            'statusCode': 200,
            'body': 'No EC2 instance IDs provided. Nothing to stop.'
        }
    
    # Parse the comma-separated string to get a list of instance IDs
    instance_ids = [instance_id.strip() for instance_id in instance_ids_str.split(',') if instance_id.strip()]
    
    if not instance_ids:
        logger.warning("No valid EC2 instance IDs provided. Nothing to stop.")
        return {
            'statusCode': 200,
            'body': 'No valid EC2 instance IDs provided. Nothing to stop.'
        }
    
    # Initialize EC2 client
    ec2_client = boto3.client('ec2')
    
    # Get the instance state for all specified instances
    describe_response = ec2_client.describe_instances(InstanceIds=instance_ids)
    
    # Filter instances that are in 'running' state
    instances_to_stop = []
    
    for reservation in describe_response['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            instance_state = instance['State