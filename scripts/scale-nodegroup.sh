#!/bin/bash

# Define variables
REGION="us-west-2"
CLUSTER_NAME="dev-eks-secondary"
NODEGROUP_NAME="dev-node-group-secondary"
DESIRED_SIZE=2

# Update the node group size
aws eks update-nodegroup-config \
    --region $REGION \
    --cluster-name $CLUSTER_NAME \
    --nodegroup-name $NODEGROUP_NAME \
    --scaling-config desiredSize=$DESIRED_SIZE

echo "Node group $NODEGROUP_NAME scaled to $DESIRED_SIZE nodes."
