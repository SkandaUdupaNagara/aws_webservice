!/bin/bash

# Set AWS region and AMI ID
export AWS_DEFAULT_REGION=us-east-1
export AMI_ID=ami-0557a15b87f6559cf

# Create a new security group with ports 80 and 22 open
export SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name mysecuritygroup --description "My security group" --output text)
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0

# Create a new key pair
export KEY_NAME=mykeypair
aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text > $KEY_NAME.pem
# Change permission of file mykeypair.pem to read only and no access to other users
chmod 400 $KEY_NAME.pem

# Launch a new instance with ports 80 and 22 open
aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type t2.micro --key-name $KEY_NAME --security-group-ids $SECURITY_GROUP_ID

# Get intance ID and public IP
export INSTANCE_ID=$(aws ec2 describe-instances --query 'Instances[0].InstanceId' --output text)
export PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

# Install Nginx web server and start the service
ssh -i $KEY_NAME.pem ubuntu@$PUBLIC_IP 'sudo apt-get update && sudo apt-get install -y nginx && sudo service nginx start'

echo "Instance launched with ID $INSTANCE_ID and public IP address $PUBLIC_IP"

