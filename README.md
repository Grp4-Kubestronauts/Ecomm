# Heya KubeAstroNuts!!

Welcome to the **Ecomm** project! This source code contains:

- A React file
- A Docker file
- A YAML file
- Terraform configuration for AWS services.

The project is fairly simple — it has a menu, an image, and a card layout displaying 3 headphone images along with their names and prices. Eventually, we’ll improve this, but feel free to contribute or share any other source code ideas.

### First Step: 
- **Create an AWS account** and set up 3 AWS Budgets.  
  Go to the **AWS console**, search for **Budgets**, and set up budgets of **5**, **8**, and **10 CAD** with email notifications for each.  
  *(You’ll thank me later!)*

---

## Step 1: Set up AWS CLI

### Set up AWS in Command Prompt
- Watch a 3-5 minute YouTube video to understand the AWS CLI setup process.

### Set up an IAM user
1. As a root user, go to **IAM users** in the AWS Management Console.
2. Create a new IAM user.
3. After creating the user, select the user and scroll down to find the **Access Keys** section.
4. Generate the **Access Key ID** and **Secret Access Key**.
5. Save these credentials to a Notepad file on your Desktop for easy access later.

### Configure AWS CLI in Command Prompt
1. Open your Command Prompt and type the following command to configure AWS CLI:

    ```bash
    aws configure
    ```

2. The CLI will prompt you for the following details:
    - **AWS Access Key ID**: Enter the **Access Key ID** generated in the previous step.
    - **AWS Secret Access Key**: Enter the **Secret Access Key** generated in the previous step.
    - **Default region name**: Enter `us-east-2` (Ohio region, as our source code is configured for this).
    - **Default output format**: Press `Enter` to leave this empty.

> **Important Reminder:**  
> Watch YouTube videos on how to set up and use AWS CLI. Ensure you have an IAM user with the secret key and access ID ready to configure the AWS CLI. Always keep the region as `us-east-2` to match the project’s configuration.

---

## Step 2: Setting up the Project in VS Code

1. **Open VS Code**:
   - Create a new folder for this project and open it in **VS Code** (`File -> Open Folder`).
   - Open the terminal in VS Code (`Ctrl + ~`).

2. **Clone the repository**:
    In the VS Code terminal, run the following command to clone the project:

    ```bash
    git clone https://github.com/Grp4-Kubestronauts/Ecomm.git
    ```

3. **Navigate to the project folder**:
    ```bash
    cd Ecomm
    ```

4. **Install dependencies**:
    Run the following command to install all necessary libraries for the React JS project:

    ```bash
    npm install
    ```

5. **Start the React app**:
    Run the following command to start the app:

    ```bash
    npm start
    ```

    The app should open in your browser at `http://localhost`. If not, check for errors in the terminal.

6. **Set up Git Bash**:
    By default, VS Code uses PowerShell for the terminal. You can change it to **Git Bash** by opening a new terminal in VS Code and selecting **Git Bash** from the dropdown.

    Once set, your terminal should show the `$` sign. If it doesn’t, the following commands won’t work.

---

## Step 3: Using Terraform to Provision AWS Infrastructure

The Terraform configuration in this project automates the creation of all required AWS services (EKS, ECR, VPC, etc.) so you don’t have to manually create them.

1. **Navigate to the Terraform folder**:

    ```bash
    cd terraform
    ```

2. **Initialize Terraform**:
    Run the following command to initialize the Terraform setup:

    ```bash
    terraform init
    ```

3. **Preview the changes** (Optional):
    Run the following command to see the resources Terraform will create or modify:

    ```bash
    terraform plan
    ```

4. **Apply Terraform configuration**:
    To create the AWS infrastructure, run:

    ```bash
    terraform apply -auto-approve
    ```

    This will take 10-25 minutes to complete, during which Terraform will create services like ECR, EKS, and the necessary AWS infrastructure.

5. **EKS Cluster**:  
    Once this is done, an EKS cluster will be created in the **us-east-2 (Ohio)** region. Be mindful that you will incur charges for the resources created.

6. **Start Docker**:
    Ensure that Docker is running on your machine while Terraform sets up the infrastructure.

7. **Deploy the App**:
    Navigate back to the main project directory and run:

    ```bash
    cd ../
    ./deploy.sh
    ```

    This script will automate the deployment of the app to your newly created Kubernetes cluster. At the
