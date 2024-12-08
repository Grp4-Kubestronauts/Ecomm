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

# Get the AWS account number
log "Fetching AWS account number..."
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# Navigate to terraform directory and get outputs
cd terraform
log "Fetching cluster names from Terraform outputs..."
CLUSTER_NAME=$(terraform output -raw cluster_name)
SECONDARY_CLUSTER_NAME=$(terraform output -raw cluster_name_secondary)
cd ..

# Get service URLs
log "Fetching service URL in primary cluster..."
PRIMARY_LB_DNS=$(kubectl get svc react-app-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' --context=arn:aws:eks:$AWS_REGION:$AWS_ACCOUNT_ID:cluster/$CLUSTER_NAME)
log "Primary Load Balancer DNS: $PRIMARY_LB_DNS"

log "Fetching service URL in secondary cluster..."
SECONDARY_LB_DNS=$(kubectl get svc react-app-service -n dr -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' --context=arn:aws:eks:$SECONDARY_AWS_REGION:$AWS_ACCOUNT_ID:cluster/$SECONDARY_CLUSTER_NAME)
log "Secondary Load Balancer DNS: $SECONDARY_LB_DNS"

# Get load balancer zone IDs
log "Fetching primary load balancer zone ID..."
PRIMARY_LB_ZONE_ID=$(aws elb describe-load-balancers \
    --query "LoadBalancerDescriptions[?DNSName==\`$PRIMARY_LB_DNS\`].CanonicalHostedZoneNameID" \
    --output text)
log "Primary Load Balancer Zone ID: $PRIMARY_LB_ZONE_ID"

log "Fetching secondary load balancer zone ID..."
SECONDARY_LB_ZONE_ID=$(aws elb describe-load-balancers \
    --region $SECONDARY_AWS_REGION \
    --query "LoadBalancerDescriptions[?DNSName==\`$SECONDARY_LB_DNS\`].CanonicalHostedZoneNameID" \
    --output text)
log "Secondary Load Balancer Zone ID: $SECONDARY_LB_ZONE_ID"

# Get Route53 hosted zone ID for kubestronauts.link
log "Fetching Route53 hosted zone ID for kubestronauts.link..."
ROUTE53_ZONE_ID=$(aws route53 list-hosted-zones --query 'HostedZones[?Name==`kubestronauts.link.`].Id' --output text | cut -d'/' -f3)
log "Route53 Zone ID: $ROUTE53_ZONE_ID"

# Create variables.auto.tfvars file
log "Generating Terraform variable file: variables.auto.tfvars..."
cat <<EOF > dnstf/variables.auto.tfvars
route53_zone_id = "$ROUTE53_ZONE_ID"
primary_load_balancer_dns_name = "$PRIMARY_LB_DNS"
primary_load_balancer_zone_id = "$PRIMARY_LB_ZONE_ID"
secondary_load_balancer_dns_name = "$SECONDARY_LB_DNS"
secondary_load_balancer_zone_id = "$SECONDARY_LB_ZONE_ID"
EOF

log "variables.auto.tfvars file created successfully."

log "Script execution completed successfully."
