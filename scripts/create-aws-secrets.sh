#!/bin/bash

# Create a JSON string with your database credentials
SECRET_STRING='{
  "host": "dbinstance-ecommerce.czqo6cyyql26.us-east-2.rds.amazonaws.com",
  "dbname": "dbinstance-ecommerce",
  "username": "postgres",
  "password": "S6uTltsZUGSdhsmlklbo",
  "port": "5432"
}'

# Create the secret in AWS Secrets Manager
aws secretsmanager create-secret \
    --name ecommerce/db \
    --description "Database credentials for ecommerce application" \
    --secret-string "$SECRET_STRING" \
    --region us-east-2 