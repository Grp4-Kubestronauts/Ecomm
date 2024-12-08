import boto3
import json
from datetime import datetime

def lambda_handler(event, context):
    region = "us-west-2"
    cluster_name = "dev-eks-secondary"
    nodegroup_name = "dev-node-group-secondary"
    desired_size = 2

    eks_client = boto3.client('eks', region_name=region)

    try:
        response = eks_client.update_nodegroup_config(
            clusterName=cluster_name,
            nodegroupName=nodegroup_name,
            scalingConfig={
                'desiredSize': desired_size
            }
        )
        print(f"Scaling node group {nodegroup_name} to {desired_size} nodes.")
        
        # Convert any datetime objects in the response to strings
        # (if there are any datetime fields like 'createdAt', 'updatedAt', etc.)
        if 'update' in response and 'createdAt' in response['update']:
            response['update']['createdAt'] = response['update']['createdAt'].isoformat()
        if 'update' in response and 'updatedAt' in response['update']:
            response['update']['updatedAt'] = response['update']['updatedAt'].isoformat()

        # Return a JSON serializable response
        return {
            'statusCode': 200,
            'body': json.dumps({
                "message": "Scaling operation successful",
                "response": response
            })
        }
        
    except Exception as e:
        print(f"Failed to scale node group: {e}")
        raise e
