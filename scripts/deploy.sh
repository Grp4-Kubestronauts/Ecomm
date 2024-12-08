#!/bin/bash

set -e

# Variables
AWS_REGION="us-east-2"  # Primary AWS region
SECONDARY_AWS_REGION="us-west-2"  # Secondary AWS region
APP_NAME="react-app"

# Function to log steps
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1"
}

# Get the AWS account number dynamically
log "Fetching AWS account number..."
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

log "AWS Account ID: $AWS_ACCOUNT_ID"

# Navigate to terraform directory and get outputs
cd terraform

log "Getting ECR repository URLs and cluster names..."
ECR_REPO=$(terraform output -raw ecr_repository_url)
SECONDARY_ECR_REPO=$(terraform output -raw ecr_repository_url_secondary)
CLUSTER_NAME=$(terraform output -raw cluster_name)
SECONDARY_CLUSTER_NAME=$(terraform output -raw cluster_name_secondary)

cd ..

# Build Docker image
log "Building Docker image..."
docker build --platform=linux/amd64 --no-cache -t $APP_NAME:latest -f docker/Dockerfile .

# Authenticate and push image to primary ECR
log "Authenticating with ECR in primary region..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO

log "Tagging and pushing image to primary ECR..."
docker tag $APP_NAME:latest $ECR_REPO:latest
docker push $ECR_REPO:latest

# Authenticate and push image to secondary ECR
log "Authenticating with ECR in secondary region..."
aws ecr get-login-password --region $SECONDARY_AWS_REGION | docker login --username AWS --password-stdin $SECONDARY_ECR_REPO

log "Tagging and pushing image to secondary ECR..."
docker tag $APP_NAME:latest $SECONDARY_ECR_REPO:latest
docker push $SECONDARY_ECR_REPO:latest

# Update kubeconfig for primary cluster
log "Updating kubeconfig for primary cluster..."
aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_REGION
kubectl config use-context arn:aws:eks:$AWS_REGION:$AWS_ACCOUNT_ID:cluster/$CLUSTER_NAME

# Deploy to Kubernetes primary cluster
log "Deploying to Kubernetes primary cluster..."
sed "s|\${ECR_REPO}|$ECR_REPO|g" k8s/deployment.yaml | kubectl apply -f -

# Wait for primary deployment
log "Waiting for deployment in primary cluster to complete..."
kubectl rollout status deployment/$APP_NAME --context=arn:aws:eks:$AWS_REGION:$AWS_ACCOUNT_ID:cluster/$CLUSTER_NAME

# Update kubeconfig for secondary cluster
log "Updating kubeconfig for secondary cluster..."
aws eks update-kubeconfig --name $SECONDARY_CLUSTER_NAME --region $SECONDARY_AWS_REGION
kubectl config use-context arn:aws:eks:$SECONDARY_AWS_REGION:$AWS_ACCOUNT_ID:cluster/$SECONDARY_CLUSTER_NAME

# Deploy to Kubernetes secondary cluster
log "Deploying to Kubernetes secondary cluster..."
sed "s|\${ECR_REPO_SECONDARY}|$SECONDARY_ECR_REPO|g" k8s/dr-deployment.yaml | kubectl apply -f -

# Wait for secondary deployment
log "Waiting for deployment in secondary cluster to complete..."
kubectl rollout status deployment/$APP_NAME -n dr --context=arn:aws:eks:$SECONDARY_AWS_REGION:$AWS_ACCOUNT_ID:cluster/$SECONDARY_CLUSTER_NAME

log "Deployment completed successfully in both regions!"

# Get service URLs
log "Service URL in primary cluster:"
kubectl get svc react-app-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' --context=arn:aws:eks:$AWS_REGION:$AWS_ACCOUNT_ID:cluster/$CLUSTER_NAME

log "Service URL in secondary cluster:"
kubectl get svc react-app-service -n dr -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' --context=arn:aws:eks:$SECONDARY_AWS_REGION:$AWS_ACCOUNT_ID:cluster/$SECONDARY_CLUSTER_NAME
