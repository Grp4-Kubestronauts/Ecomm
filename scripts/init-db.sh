#!/bin/bash

# Database connection parameters
DB_HOST="dbinstance-ecommerce.czqo6cyyql26.us-east-2.rds.amazonaws.com"
DB_NAME="dbinstance-ecommerce"
DB_USER="postgres"
DB_PASSWORD="S6uTltsZUGSdhsmlklbo"

# Function to log steps
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1"
}

# Check if psql is installed
if ! command -v psql &> /dev/null; then
    log "PostgreSQL client is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install -y postgresql-client
fi

# Initialize database
log "Initializing database..."
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f db/init.sql

if [ $? -eq 0 ]; then
    log "Database initialization completed successfully"
else
    log "Error: Database initialization failed"
    exit 1
fi

# Upload sample images to S3
log "Uploading sample images to S3..."
aws s3 cp images/watch.jpg s3://ecommerce-bucket-kube/products/watch.jpg
aws s3 cp images/shoe.jpg s3://ecommerce-bucket-kube/products/shoe.jpg
aws s3 cp images/shirt.jpg s3://ecommerce-bucket-kube/products/shirt.jpg

log "Setup complete!" 