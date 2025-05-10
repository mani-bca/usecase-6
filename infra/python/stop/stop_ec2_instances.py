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
            instance_state = instance['State']['Name']
            
            if instance_state == 'running':
                instances_to_stop.append(instance_id)
                logger.info(f"Instance {instance_id} is running and will be stopped.")
            else:
                logger.info(f"Instance {instance_id} is in {instance_state} state. No action needed.")
    
    if not instances_to_stop:
        logger.info("No running instances found. Nothing to stop.")
        return {
            'statusCode': 200,
            'body': 'No running instances found. Nothing to stop.'
        }
    
    # Stop the running instances
    response = ec2_client.stop_instances(InstanceIds=instances_to_stop)
    
    # Log the result
    stopping_instances = response['StoppingInstances']
    for instance in stopping_instances:
        instance_id = instance['InstanceId']
        previous_state = instance['PreviousState']['Name']
        current_state = instance['CurrentState']['Name']
        logger.info(f"Instance {instance_id} state changing from {previous_state} to {current_state}")
    
    return {
        'statusCode': 200,
        'body': f'Successfully initiated stop for {len(stopping_instances)} instances.'
    }