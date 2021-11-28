import os
import json
import boto3
import logging
from datetime import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('instance_state')


def get_instances(label_key: str, label_value: str) -> list:
    client = boto3.client('ec2')

    custom_filter = [{
        'Name': f'tag:{label_key}',
        'Values': [label_value]}]
    response = client.describe_instances(Filters=custom_filter)

    return response['Reservations']


def get_instances_data(instances: list) -> dict:
    instances_data = dict()
    for instance in instances:
        instance_id = instance['Instances'][0]["InstanceId"]
        state_name = instance['Instances'][0]["State"]["Name"]
        state_code = instance['Instances'][0]["State"]["Code"]
        instances_data[instance_id] = {"state_name": state_name, 'state_code': state_code}
    return instances_data


def add_item(instance_id: str, instance_state_name: str, instance_state_code: str, table=table)-> None:

    table.put_item(
       Item={
            'state_code': instance_state_code,
            "state_name": instance_state_name,
            'instance_id': instance_id,
            "added_at": datetime.utcnow().isoformat()
        }
    )
    logger.debug(f"Added item to table {table}")


def lambda_handler(event, context):

    instances = get_instances(label_key="Owner", label_value="Manuel Rodriguez")
    instances_data = get_instances_data(instances)

    for instance, data in instances_data.items():
        add_item(instance, data['state_name'], data["state_code"],table=table)

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "Table edited ": datetime.now().strftime("%d/%m/%y")
        })
    }