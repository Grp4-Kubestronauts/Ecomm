#!/bin/bash

set -e

# Variables
AWS_REGION="us-east-2"  # Change this to your region
APP_NAME="react-app"

# Function to log steps
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1"
}

cd ..
# Navigate to terraform directory and get outputs
cd terraform

log "Getting ECR repository URL..."
ECR_REPO=$(terraform output -raw ecr_repository_url)
CLUSTER_NAME=$(terraform output -raw cluster_name)

cd ..

# Build Docker image
log "Building Docker image..."
docker build -t $APP_NAME:latest -f docker/Dockerfile .

# Authenticate with ECR
log "Authenticating with ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO

# Tag and push image
log "Tagging and pushing image to ECR..."
docker tag $APP_NAME:latest $ECR_REPO:latest
docker push $ECR_REPO:latest

# Update kubeconfig
log "Updating kubeconfig..."
aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_REGION

# Deploy to Kubernetes
log "Deploying to Kubernetes..."
sed "s|\${ECR_REPO}|$ECR_REPO|g" k8s/deployment.yaml | kubectl apply -f -

# Wait for deployment
log "Waiting for deployment to complete..."
kubectl rollout status deployment/$APP_NAME

log "Deployment completed successfully!"

# Get service URL
log "Service URL:"
kubectl get svc react-app-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
