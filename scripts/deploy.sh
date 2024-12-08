#!/bin/bash
set -e

# Function to log steps
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1"
}

# Gets the script and project_root path store in these variables for convience
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #Ecomm\scripts
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

AWS_REGION='us-east-2'

# This fetches the ECR and Cluster "nameS" from via the terraform
log "Getting ECR repository URLs and cluster names..."

cd "${PROJECT_ROOT}/terraform/modules" 

FRONTEND_ECR_REPO=$(terraform output -raw frontend_ECR_url)
BACKEND_CART_ECR_REPO=$(terraform output -raw backend_ECR_url)
CLUSTER_NAME=$(terraform output -raw cluster_name)


log "Connecting to right cluster vis kubeconfig"
aws eks --region $AWS_REGION update-kubeconfig --name ${CLUSTER_NAME}



# This creates your db deatils inside K8's 
log "Running create-secrets.sh file"
cd "${PROJECT_ROOT}/scripts"
./create-secrets.sh

# This saves the database details in AWS secret manager
log "Setting up AWS Secrets..."
if ! aws secretsmanager describe-secret --secret-id ecommerce2/db2 >/dev/null 2>&1; then
    log "Creating AWS Secrets..."
    ./create-aws-secrets.sh
fi

# Source environment variables
log "Path: ${SCRIPT_DIR}/set-env.sh"
source "${SCRIPT_DIR}/set-env.sh"  #Ecomm\scripts\set-env


#Creates a bucket
log "Creating a bucket"
if aws s3api head-bucket --bucket "ecommerce-bucket-kube2" 2>/dev/null; then
    echo "Bucket 'ecommerce-bucket-kube2' already exists."
else
    echo "Bucket 'ecommerce-bucket-kube2' does not exist. Creating a new bucket..."
    # Create a new bucket
    aws s3api create-bucket --bucket "ecommerce-bucket-kube2" --region "$REGION" --create-bucket-configuration LocationConstraint="$REGION"
    echo "Bucket 'ecommerce-bucket-kube2' created successfully."

    log "Uploading sample images to S3..."
    cd "${PROJECT_ROOT}/images/"
    pwd
    aws s3 cp watch.jpg s3://ecommerce-bucket-kube2/products/watch.jpg
    aws s3 cp shoe.jpg s3://ecommerce-bucket-kube2/products/shoe.jpg
    aws s3 cp shirt.jpg s3://ecommerce-bucket-kube2/products/shirt.jpg

fi

# Deploys secrets.yaml and Service account
log "Creating Kubernetes configurations..."
aws eks --region ${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME}

kubectl apply -f "${PROJECT_ROOT}/k8s/secrets/cart-service-secrets.yaml"
kubectl apply -f "${PROJECT_ROOT}/k8s/backend/cart-service-account.yaml"

# Building backend Docker file
log "------------------------------------------Building backend docker---------------------------"
cd "${PROJECT_ROOT}/backend/cart-service"
pwd
docker build -t cart-service:latest .
docker tag cart-service:latest ${BACKEND_CART_ECR_REPO}:latest
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${BACKEND_CART_ECR_REPO%/*}
docker push ${BACKEND_CART_ECR_REPO}:latest


# Deploying backend's yaml file
log "------------------------------------------Deploying backend to Kubernetes-------------------"
sed "s|\$ECR_REPO|${BACKEND_CART_ECR_REPO}|g" "${PROJECT_ROOT}/k8s/backend/cart-service.yaml" | kubectl apply -f -

# Function to get cart service URL
get_cart_service_url() {
    kubectl get svc cart-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
}


# Wait for cart service
#log "Waiting for cart service deployment..."
#kubectl rollout status deployment/cart-service

# Get Cart Service URL #line 36
CART_API_URL=$(get_cart_service_url)  #kubectl get svc cart-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
if [ -z "$CART_API_URL" ]; then
    log "Failed to get Cart Service URL"
    exit 1
fi



# Docker build frontend
log "------------------------------------------Building frontend docker---------------------------"
cd "${PROJECT_ROOT}/frontend"
docker build -t frontend:latest \
  --build-arg REACT_APP_API_URL="http://${CART_API_URL}" \
   -f docker/Dockerfile .
docker tag frontend:latest ${FRONTEND_ECR_REPO}:latest
docker push ${FRONTEND_ECR_REPO}:latest

# Deploy Frontend yaml files
log "------------------------------------------Deploying frontend to Kubernetes-------------------"
sed -e "s|\$REPO|${FRONTEND_ECR_REPO}|g; s|\$CART_URL|${CART_API_URL}|g" "${PROJECT_ROOT}/k8s/frontend/deployment.yaml" | kubectl apply -f -


# Wait for frontend deployment
#log "Waiting for frontend deployment..."
kubectl rollout status deployment/react-app

log "Deployment complete!"
log "Frontend URL: $(kubectl get svc react-app-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')"
log "Cart Service URL: $CART_API_URL/api/products"