# Project Deployment Guide

## Prerequisites
- AWS CLI installed and configured
- Terraform installed
- kubectl installed
- PostgreSQL client installed

## Infrastructure Setup

### 1. Initialize AWS Infrastructure with Terraform
```bash
cd terraform/modules
terraform init
terraform plan
terraform validate
terraform apply --auto-approve
```

### 2. Update Kubernetes Configuration
```bash
aws eks update-kubeconfig --name react-app-eks --region us-east-2
```

### 3. Create AWS Secrets
Update `create-aws-secrets.sh` with the following details:
```
- `host`: <database endpoint>
- `dbname`: <db name>
- `username`: <username>
- `password`: <your db password>
- `port`: 5432
```

Then run:
```bash
chmod +x create-aws-secrets.sh
./create-aws-secrets.sh
```

### 4. Configure Environment Variables
Create a `.env` file with the following contents:
```
REACT_APP_API_URL=<To be updated after deployment>
DB_HOST=<Your endpoint URL>
DB_NAME=<DB name>
DB_USER=<DB username>
DB_PASSWORD=<your password>
DB_PORT=5432
AWS_REGION=us-east-2
PORT=3001
```

### 5. Database Initialization
Connect to the RDS instance:
```bash
psql -h <RDS_ENDPOINT> -U postgres -d dbinstance-ecommerce
\c dbinstance-ecommerce
```
Refer the `db/init.sql` for the queries. You can copy paste the query.

### 6. Kubernetes Configuration Updates
#### Update `cart-service.yaml`
- Replace `<add your account id>` in the image URL:
  ```yaml
  image: <your account id>.dkr.ecr.us-east-2.amazonaws.com/dev-cart-service:latest
  ```

#### Update `cart-service-account.yaml`
- Add your AWS account ID to the role ARN:
  ```yaml
  eks.amazonaws.com/role-arn: arn:aws:iam::<Your Account ID>:role/cart-service-role
  ```

#### Update `deployment.yaml`
- Update image URL:
  ```yaml
  image: <your account id>.dkr.ecr.us-east-2.amazonaws.com/react-app-repo:latest
  ```
- Replace cart-service URL after first deployment
  ```yaml
  value: "Replace this with the cart-servie URL you get after first deployment"
  ```  

####Update cart-service-secrets.yaml
```yaml
stringData:
  database-url: "postgresql://postgres:<password>@<endpoint url>:5432/<dbname>"
  s3-bucket: "ecommerce-bucket-kube"
  aws-region: "us-east-2"
  api-url: "<cart service url>"
```


## Useful Kubernetes Commands
```bash
# List all pods
kubectl get pods

# List all services
kubectl get services

# View pod logs
kubectl logs <pod-name>
```

## Deployment Notes
- Run `./deploy.sh` first
- After initial deployment, update `REACT_APP_API_URL` and cart-service URL in configurations
- Re-run deployment script after updates
