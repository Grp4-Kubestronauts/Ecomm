
1. Then, set up the AWS infrastructure using Terraform:
    Copy the tf file provided by bosco to the terraform/modules folder
    cd terraform/modules
    terraform init
    terraform plan
    terraform validate
    terraform apply --auto-approve

    Please update the region using this command `aws eks update-kubeconfig --name react-app-eks --region us-east-2`



2. Change the create-aws-secrets.sh
    host: <database endpoint>
    dbname: <db name>
    username: <username>
    password: <tour db password>
    port: 5432

    After updating this:
    `chmod +x create-aws-secrets.sh`
    `./create-aws-secrets.sh`

3. Create a .env file and add these details:
    REACT_APP_API_URL=<You will get this after you make the below changes and running the script. Then update this and run the script again>
    DB_HOST=<Your endpoint URL>
    DB_NAME=<DB name>
    DB_USER=<DB username>
    DB_PASSWORD=<yourpassword>
    DB_PORT=5432
    AWS_REGION=us-east-2
    PORT=3001

4. Once the ec2 is created connect to the ec2. Then:
    `psql -h <RDS_ENDPOINT> -U postgres -d dbinstance-ecommerce`

    `\c dbinstance-ecommerce`

    Then check the db/init SQL and copy paste the query.
    

5. Some changes in the k8s folder:
    Update cart-service.yaml
        add your acount id `image: <add your account id>.dkr.ecr.us-east-2.amazonaws.com/dev-cart-service:latest` 
    update cart-service-account.yaml
       ` eks.amazonaws.com/role-arn: arn:aws:iam::<Add your id>:role/cart-service-role`

    update deployment.yaml
        `image: <your id>.dkr.ecr.us-east-2.amazonaws.com/react-app-repo:latest` 
        value: "replace with your cart-service URL (dont change it now, first run the ./deploy.sh, after that you will get a CART_SERVICE URL, then replace that here and run the script again)
    
