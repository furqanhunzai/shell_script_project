#!/bin/bash

###################################
# this script will create a new s3 bucket
# it will check if aws cli is installed
# and if the user is authenticated
################################### 


# Check if AWS CLI is installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI could not be found. Please install it first."
    exit 1
fi      

# Check if user is authenticated
if ! aws sts get-caller-identity &> /dev/null
then
    echo "You are not authenticated. Please configure your AWS CLI with valid credentials."
    exit 1
fi

# Prompt for bucket name
read -p "Enter the name of the S3 bucket to create: " BUCKET_NAME
# Create the S3 bucket
aws s3 mb s3://$BUCKET_NAME
if [ $? -eq 0 ]; then
    echo "S3 bucket '$BUCKET_NAME' created successfully."
else
    echo "Failed to create S3 bucket '$BUCKET_NAME'."
fi




