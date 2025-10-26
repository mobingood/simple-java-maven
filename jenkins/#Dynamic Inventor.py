#Dynamic Inventor


##python
import boto3
import json

def get_ec2_instances():
    ec2 = boto3.client('ec2')
    response = ec2.describe_instances(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
    inventory = {'all': {'hosts': []}}
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            inventory['all']['hosts'].append(instance['PublicIpAddress'])
    return inventory

if __name__ == '__main__':
    inventory = get_ec2_instances()
    print(json.dumps(inventory, indent=2))
