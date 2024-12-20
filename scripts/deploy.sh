#!/bin/bash

set -e



# Function to log steps
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1"
}

# Get the absolute path to the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

update_kubeconfig() {
    log "Updating kubeconfig with latest cluster endpoint..."
    aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}
}


# Source environment variables
source "${SCRIPT_DIR}/set-env.sh"
update_kubeconfig 

# Login to ECR
log "Authenticating with ECR..."
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${CART_ECR_REPO%/*}

# Function to check required environment variables
check_env_vars() {
    local required_vars=("CART_ECR_REPO" "FRONTEND_ECR_REPO")
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            log "Error: Required environment variable $var is not set"
            exit 1
        fi
    done
}

# Function to get cart service URL
get_cart_service_url() {
    kubectl get svc cart-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
}

# Check required environment variables
check_env_vars

# Create Kubernetes configurations
log "Creating Kubernetes configurations..."
kubectl apply -f "${PROJECT_ROOT}/k8s/secrets/cart-service-secrets.yaml"
kubectl apply -f "${PROJECT_ROOT}/k8s/backend/cart-service-account.yaml"

log "Setting up AWS Secrets..."
if ! aws secretsmanager describe-secret --secret-id ecommerce/db >/dev/null 2>&1; then
    log "Creating AWS Secrets..."
    ./create-aws-secrets.sh
fi



# Build and deploy cart service
log "Building cart service..."
cd "${PROJECT_ROOT}/backend/cart-service"
docker build -t cart-service:latest .
docker tag cart-service:latest ${CART_ECR_REPO}:latest
docker push ${CART_ECR_REPO}:latest

# Deploy cart service k8s resources
log "Deploying cart service to Kubernetes..."
sed -e "s|\${ECR_REPO_CART}|$CART_ECR_REPO|g" \
    "${PROJECT_ROOT}/k8s/backend/cart-service.yaml" | kubectl apply -f -

# Wait for cart service
log "Waiting for cart service deployment..."
kubectl rollout status deployment/cart-service

# Get Cart Service URL
CART_API_URL=$(get_cart_service_url)
if [ -z "$CART_API_URL" ]; then
    log "Failed to get Cart Service URL"
    exit 1
fi

log "Cart Service URL: $CART_API_URL"

# Build and deploy frontend
log "Building frontend..."
cd "${PROJECT_ROOT}/frontend"
docker build -t frontend:latest \
  --build-arg REACT_APP_API_URL="http://${CART_API_URL}" \
  -f docker/Dockerfile .
docker tag frontend:latest ${FRONTEND_ECR_REPO}:latest
docker push ${FRONTEND_ECR_REPO}:latest

# Deploy frontend k8s resources
log "Deploying frontend to Kubernetes..."
sed -e "s|\${ECR_REPO_FRONTEND}|$FRONTEND_ECR_REPO|g" \
    "${PROJECT_ROOT}/k8s/frontend/deployment.yaml" | kubectl apply -f -

# Wait for frontend deployment
log "Waiting for frontend deployment..."
kubectl rollout status deployment/react-app

log "Deployment complete!"
log "Frontend URL: $(kubectl get svc react-app-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')"
log "Cart Service URL: $CART_API_URL"