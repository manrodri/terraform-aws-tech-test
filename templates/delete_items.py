import os
import json

from boto3.dynamodb.conditions import Key, Attr
import boto3

import logging
from datetime import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)

table_name = os.environ.get('TABLE_NAME')
label_key = os.environ.get('LABEL_KEY')
label_value = os.environ.get('LABEL_VALUE')

dynamodb = boto3.resource('dynamodb')


def scan(table_name):
    table = dynamodb.Table(table_name)
    response = table.scan()
    return response['Items']


def delete_one_item(instance_id, table_name):
    table = dynamodb.Table(table_name)
    table.delete_item(
        Key={
            'instance_id': instance_id,
        }
    )


def lambda_handler(event, context):
    items = scan(table_name)
    [delete_one_item(item['instance_id'], table_name) for item in items]

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "Table cleaned up date ": datetime.now().strftime("%d/%m/%y")
        })
    }
