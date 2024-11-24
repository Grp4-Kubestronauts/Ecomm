#!/bin/bash

# 1. Install Java JDK 17
echo "Installing Java JDK 17..."
sudo apt update
sudo apt install openjdk-17-jdk -y

# 2. Install AWS CLI using curl and unzip
echo "Installing AWS CLI..."
sudo apt update
sudo apt install unzip curl -y
curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv1.zip"
unzip awscliv1.zip
sudo ./aws/install

# 3. Install Docker
echo "Installing Docker..."
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo "Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker
echo "Installing Docker packages..."
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# 4. Install Jenkins
echo "Installing Jenkins..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y

# Start Jenkins service
echo "Starting Jenkins..."
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins

# Retrieve Jenkins password
echo "Retrieving Jenkins initial admin password..."
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Add Jenkins user to Docker group to bypass sudo permissions for Docker commands
echo "Adding Jenkins user to Docker group..."
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

# 5. Install Terraform
echo "Installing Terraform..."
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt-get install terraform -y

# 6. Install kubectl

echo "Installing Kubectl right noq..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# 7. Verify if u got kubectl installed...:

echo "If the following of the following command should show a url path that's where ur kubeconfig exists if no url then chatgpt how to setup kubeconfig"

ls -l /home/ubuntu/.kube/config

sudo usermod -aG ubuntu jenkins
sudo chmod 664 /home/ubuntu/.kube/config
sudo systemctl restart jenkins



echo "Setup complete!"
