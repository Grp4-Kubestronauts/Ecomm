#!/bin/bash

# AWS Configuration
export AWS_REGION=us-east-2
export S3_BUCKET=ecommerce-bucket-kube
export CART_ECR_REPO="392294087512.dkr.ecr.us-east-2.amazonaws.com/dev-cart-service"
export FRONTEND_ECR_REPO="392294087512.dkr.ecr.us-east-2.amazonaws.com/react-app-repo"


# Try to get secrets from AWS Secrets Manager, fall back to environment variables if not available
if ! DB_SECRETS=$(aws secretsmanager get-secret-value --secret-id ecommerce/db --query SecretString --output text 2>/dev/null); then
    echo "Warning: Could not fetch secrets from AWS Secrets Manager. Using environment variables."
    # Use values from k8s secrets as fallback
    export DB_HOST=$DB_HOST
    export DB_NAME=$DB_NAME
    export DB_USER=$DB_USER
    export DB_PASSWORD=$DB_PASSWORD
    export DB_PORT=$DB_PORT
else
    # Extract values from AWS Secrets Manager response
    export DB_HOST=$(echo $DB_SECRETS | jq -r .host)
    export DB_NAME=$(echo $DB_SECRETS | jq -r .dbname)
    export DB_USER=$(echo $DB_SECRETS | jq -r .username)
    export DB_PASSWORD=$(echo $DB_SECRETS | jq -r .password)
    export DB_PORT=$(echo $DB_SECRETS | jq -r .port)
fi

# Application Configuration
export PORT=3001