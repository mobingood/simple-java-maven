# Py shutdown Ec2 instance

import boto3

ec2 = boto3.client("ec2", region_name="ap-south-1")

# List of instances having tag Shutdown=6pm
instances = ec2.describe_instances(
    Filters=[
        {"Name": "tag:Shutdown", "Values": ["6pm"]},
        {"Name": "instance-state-name", "Values": ["running"]}
    ]
)

# Build the list
server_list = []
for reservation in instances["Reservations"]:
    for instance in reservation["Instances"]:
        server_list.append(instance["InstanceId"])

# Loop style like you requested
for server in server_list:
    print(f"Stopping server: {server}")
    ec2.stop_instances(InstanceIds=[server])

print("All shutdown initiated.")
