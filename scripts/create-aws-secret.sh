#!/bin/bash

# Get your AWS credentials
AWS_ACCESS_KEY=$(aws configure get aws_access_key_id)
AWS_SECRET_KEY=$(aws configure get aws_secret_access_key)

# Create Kubernetes secret
kubectl create secret generic aws-credentials \
  --from-literal=access-key=$AWS_ACCESS_KEY \
  --from-literal=secret-key=$AWS_SECRET_KEY \
  --from-literal=region=us-east-2 