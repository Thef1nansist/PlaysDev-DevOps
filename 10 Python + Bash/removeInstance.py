import boto3
import sys

client = boto3.client('ec2')
if (sys.argv[1]):
    response = client.terminate_instances(
    InstanceIds=[
        sys.argv[1],
    ],
)

print(response)