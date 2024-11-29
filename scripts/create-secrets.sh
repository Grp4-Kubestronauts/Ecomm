#!/bin/bash

# Source environment variables
source .env

# Create Kubernetes secret
kubectl create secret generic cart-service-secrets \
  --from-literal=db-host="$DB_HOST" \
  --from-literal=db-name="$DB_NAME" \
  --from-literal=db-user="$DB_USER" \
  --from-literal=db-password="$DB_PASSWORD" \
  --from-literal=db-port="$DB_PORT" \
  --dry-run=client -o yaml | kubectl apply -f -

# Verify secret was created
kubectl get secret cart-service-secrets 