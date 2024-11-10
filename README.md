# Heya KubeAstroNuts!!

 This source code has a react file, docker file, yaml file and terraform. 
 The source is quite basic, it has a menu, image and a card layout such that it will display 3 headphone images along with the name and price. Eventually will make it better or any other source code is also appreciated.

Firstly definitely create an AWS account, and create 3 aws budgets. Go to AWS console search budgets and set budgets of 5, 8, and 10 cad with notification to your email ids. (Do this! will thank me later) 

## Step 1: 
- Set up AWS in command prompt (watch random yt videos 3-5mins)
- Set up an IAM user, As a root user go to IAM users, create a new one, after creating select the user and scroll down to see add secret access id. Generate id and password save it as a notepad file in dekstop to view whenever needed. 
- Open cmd and type 
```bash
aws configure
 should ask you to input the IAM user id, password, region and json(leave this 4th one empty by pressing enter). Remember to put region as "us-east-2". It's Ohio region our source code is configured with us-east-2.

 Reminder: (Watch youtube videos on how to setup and use aws cli. You should have an Iam User too with secret key access such that you will feed it to your cmd with aws configure. Keep the region us-east-2.)

## Step 2:
- Firstly I used VS code. Make a folder for this project and open Vs code File -> Select folder (select the one you created) and open terminal (shift ~). 

  -Type the following in VsCOde terminal:
   git clone https://github.com/Grp4-Kubestronauts/Ecomm.git
   and all the code will be downloaded to that folder.
 
  - type "cd Ecomm"
   Remember to cd to Ecomm and proceed with: "npm install" (This should install all the necessary libraries that we used for the react js source code).
   
   - Do "npm start" to check if the app opened up in your browser as localhost (if not then there are errors with the source code, ChatGPT it)
   
   - Now the terminal u are running is mostly powershell select a new terminal with git bash in vscode itslef
   
   - You should see a $ sign now else none of the below commands will work.


## Step 3: Using Terraform as an Infrastructure as a Code. This terraform has all the Amazon service needed such that you dont have to individually create any services like EKS, ECR, VPC etc

  -  "cd terraform" 
   
   - "terraform init" (this will set terraform essentials in your folder)
   
   - "terraform plan" (This will show what files are updated, optional, just for info)
   
   - "terraform apply -auto-approve" (This is the creation part where your ECR, EKS, Node group and all the amazon service will be created. This should takes 10- 25 mins.)
   
   - Once this is done, EKS cluster is created in Ohio region (us-east-2). Remember from this minute onwards you will be charged $$$ (not much).
   
   - Remember to start your Docker app, leave it there, and return to Vscode.
   
   - cd ../
   
   - ./deploy.sh   (This is a script that puts a list of commands on its own and in the end if all goes good it should give you a AWS URL link where our site will be hosted with kubernetes)


   
# Congrats! though we got more to do in it.

## Step 4:

   - Also since ur cluster is running it will cost u the time from when it's started and utilized. If you forget to delete then would cost u a price of a chocolate everyday. Since u created most of the AWS service via terraform, u can delete wtever terraform created by putting the following command.
   
   - terraform destroy <br/><br/>
   this should take around 5-10 mins and delete whatever it created but still manually check EKS, ECR/private repository, EC2 dashboard, Network interface, Load balancer, network gateway.
   
   - next day and day after tommorow search cost explorer in aws console and check if its charging you more coz that's how I learnt i didn't delete some resources and paid the price of 3 biriyanis to AWS :)
   - 


# Heading Level 1 (Largest)
## Heading Level 2
### Heading Level 3
#### Heading Level 4
##### Heading Level 5
###### Heading Level 6 (Smallest)


Inline `code` example.
bash
echo "Hello, World!"

```bash
echo "Hello, World!" 

   ```bash
# This is a bash command
git clone https://github.com/yourrepo.git

