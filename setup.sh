#!/bin/bash

# Function to create directories
create_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo "Created directory: $1"
    else
        echo "Directory already exists: $1"
    fi
}

# Create new project structure
echo "Setting up new project structure..."

# Frontend directories
create_dir "frontend/public"
create_dir "frontend/src/components"
create_dir "frontend/src/hooks"
create_dir "frontend/src/services"
create_dir "frontend/src/styles"
create_dir "frontend/src/utils"
create_dir "frontend/docker"

# Backend directories
create_dir "backend/cart-service/src/controllers"
create_dir "backend/cart-service/src/routes"
create_dir "backend/cart-service/src/services"
create_dir "backend/cart-service/src/models"

# Kubernetes directories
create_dir "k8s/frontend"
create_dir "k8s/backend"

# Terraform directories
create_dir "terraform/modules/ecr"
create_dir "terraform/modules/eks"
create_dir "terraform/modules/vpc"

# Move frontend files
echo "Moving frontend files..."
mv public/* frontend/public/
mv src/* frontend/src/
mv docker/Dockerfile frontend/docker/

# Move backend files
echo "Moving backend files..."
mv cart-service/src/* backend/cart-service/src/
mv cart-service/Dockerfile backend/cart-service/
mv cart-service/package.json backend/cart-service/

# Move Kubernetes files
echo "Moving Kubernetes files..."
mv k8s/deployment.yaml k8s/frontend/
mv k8s/cart-service.yaml k8s/backend/

# Move Terraform files
echo "Moving Terraform files..."
mv terraform/*.tf terraform/modules/

# Move scripts
echo "Moving scripts..."
mv scripts/deploy.sh scripts/init-db.sh scripts/set-env.sh scripts/

echo "Project structure setup complete!" 