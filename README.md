# aws_webservice
# # Automated way to deploy an AWS instance that is running Nginx(port 80) webservice

High-level overview of how to create an automated way to deploy an AWS instance (free tier) that is running Nginx (port 80) web service:

This script does the following:

1. Sets the AWS region and AMI ID.
2. Creates a new security group with port 80 open.
3. Creates a new key pair for accessing the instance.
4. Launches a new Ubuntu EC2 instance with port 80 open, using the specified security group and key pair and retrive instance ID
5. Waits for the instance to be running.
6. Retrieves the public IP address of the instance.
7. Logs in to the instance via SSH using the key pair and installs Nginx web server.
8. Starts the Nginx service.
9. Copy/transfer index.html to ec2 instance.
10. Move index.html to /var/www/html

Note: AWS CLI installed and configured with AWS account credentials before running the script. 
