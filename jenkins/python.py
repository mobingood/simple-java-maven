#!/bin/python3

import paramiko
import boto3
import requests

def copy_file_to_nodes(jump_host, jump_user, jump_key, nodes, remote_path, local_path):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(jump_host, username=jump_user, key_filename=jump_key)
    
    for node in nodes:
        print(f"Copying file to {node}...")
        command = f"scp -o ProxyJump={jump_user}@{jump_host} {local_path} {node}:{remote_path}"
        ssh.exec_command(command)
    
    ssh.close()
    print("File copy completed.")

def deploy_application(nodes, deploy_script):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    for node in nodes:
        ssh.connect(node, username="ec2-user", key_filename="~/.ssh/node.pem")
        print(f"Deploying application on {node}...")
        ssh.exec_command(f"bash {deploy_script}")
        ssh.close()
    
    print("Deployment completed.")

def clean_log_files(nodes, log_paths):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    for node in nodes:
        ssh.connect(node, username="ec2-user", key_filename="~/.ssh/node.pem")
        for log_path in log_paths:
            print(f"Cleaning log file {log_path} on {node}...")
            ssh.exec_command(f"> {log_path}")
        ssh.close()
    
    print("Log cleanup completed.")

def create_users(nodes, users):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    for node in nodes:
        ssh.connect(node, username="ec2-user", key_filename="~/.ssh/node.pem")
        for user in users:
            print(f"Creating user {user} on {node}...")
            ssh.exec_command(f"sudo useradd -m {user}")
        ssh.close()
    
    print("User creation completed.")

def get_aws_inventory():
    ec2 = boto3.client("ec2")
    instances = ec2.describe_instances()
    inventory = []
    
    for reservation in instances["Reservations"]:
        for instance in reservation["Instances"]:
            inventory.append({
                "InstanceId": instance["InstanceId"],
                "State": instance["State"]["Name"],
                "PrivateIpAddress": instance.get("PrivateIpAddress", "N/A"),
            })
    
    print("AWS Inventory:", inventory)
    return inventory

def get_servicenow_inventory(instance, user, password):
    url = f"https://{instance}.service-now.com/api/now/table/cmdb_ci_server"
    response = requests.get(url, auth=(user, password), headers={"Accept": "application/json"})
    
    if response.status_code == 200:
        inventory = response.json()["result"]
        print("ServiceNow Inventory:", inventory)
        return inventory
    else:
        print("Failed to fetch inventory from ServiceNow")
        return None

def deploy_aws_instances(ami_id, instance_type, key_name, security_group, subnet_id, count=1):
    ec2 = boto3.client("ec2")
    response = ec2.run_instances(
        ImageId=ami_id,
        InstanceType=instance_type,
        KeyName=key_name,
        SecurityGroupIds=[security_group],
        SubnetId=subnet_id,
        MinCount=count,
        MaxCount=count
    )
    
    instances = [instance["InstanceId"] for instance in response["Instances"]]
    print("Deployed AWS Instances:", instances)
    return instances

# Example Usage:
# copy_file_to_nodes("jump.server.com", "ec2-user", "~/.ssh/jump.pem", ["node1", "node2"], "/tmp/app", "./app.tar.gz")
# deploy_application(["node1", "node2"], "/tmp/deploy.sh")
# clean_log_files(["node1", "node2"], ["/var/log/syslog", "/var/log/auth.log"])
# create_users(["node1", "node2"], ["user1", "user2"])
# get_aws_inventory()
# get_servicenow_inventory("your-instance", "your-username", "your-password")
# deploy_aws_instances("ami-12345678", "t2.micro", "my-key", "sg-12345678", "subnet-12345678", count=2)
