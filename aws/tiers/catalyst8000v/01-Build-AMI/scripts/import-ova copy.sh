#!/bin/bash

# Set variables
FILE_PATH="container.json"
AWS_REGION="us-east-1"
AMI_NAME="my-cisco8000v-ami"
INSTANCE_TYPE="t2.micro"

# Import OVA file to EC2
IMPORT_TASK_ID=$(aws ec2 import-image \
    --region $AWS_REGION \
    --architecture x86_64 \
    --platform Linux \
    --description "My Cisco 8000v OVA image" \
    --license-type BYOL \
    --disk-containers $FILE_PATH \
    --output json \
    --query 'ImportTaskId' \
    --profile default)

# Wait for import task to complete
aws ec2 wait import-image-task-completed \
    --region $AWS_REGION \
    --import-task-id $IMPORT_TASK_ID \
    --profile default

# Create AMI from imported image
IMPORTED_IMAGE_ID=$(aws ec2 describe-import-image-tasks \
    --region $AWS_REGION \
    --import-task-ids $IMPORT_TASK_ID \
    --query 'ImportImageTasks[0].ImageId' \
    --output text \
    --profile default)

aws ec2 create-image \
    --region $AWS_REGION \
    --instance-id $IMPORTED_IMAGE_ID \
    --name $AMI_NAME \
    --description "My Cisco 8000v AMI" \
    --block-device-mappings "[{\"DeviceName\":\"/dev/sda1\",\"Ebs\":{\"DeleteOnTermination\":true,\"VolumeSize\":8,\"VolumeType\":\"gp2\"}}]" \
    --virtualization-type hvm \
    --output json \
    --query 'ImageId' \
    --profile default

# Wait for AMI creation to complete
aws ec2 wait image-available \
    --region $AWS_REGION \
    --image-ids $AMI_ID \
    --profile default

# Clean up imported image
aws ec2 deregister-image \
    --region $AWS_REGION \
    --image-id $IMPORTED_IMAGE_ID \
    --profile default
