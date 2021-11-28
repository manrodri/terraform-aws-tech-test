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


def get_instances_ids(instances: list) -> list:
    return [instance['Instances'][0]["InstanceId"] for instance in instances]


def delete_one_item(instance_id, table=table):
    table.delete_item(
        Key={
            'instance_id': instance_id,
        }
    )


def delete_all_items(instance_ids: list, this_table=table):

    with this_table.batch_writer() as batch:
        for instance_id in instance_ids:

            batch.delete_item(
                Key={
                    'instance_id': instance_id,
                }
            )



def lambda_handler(event, context):

    instances = get_instances(label_key="Owner", label_value="Manuel Rodriguez")
    instance_ids = get_instances_ids(instances)

    [delete_one_item(instance_id) for instance_id in instance_ids]


    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "Table cleaned up date ": datetime.now().strftime("%d/%m/%y")
        })
    }
