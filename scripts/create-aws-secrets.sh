#!/bin/bash

# Create a JSON string with your database credentials
SECRET_STRING='{
  "host": "mydb2.cfwsoy60i9bt.us-east-2.rds.amazonaws.com",
  "dbname": "ecomm",
  "username": "postgres",
  "password": "admin12345",
  "port": "5432"
}'

# Create the secret in AWS Secrets Manager
aws secretsmanager create-secret \
    --name ecommerce2/db2 \
    --description "Database credentials for ecommerce application" \
    --secret-string "$SECRET_STRING" \
    --region us-east-2 