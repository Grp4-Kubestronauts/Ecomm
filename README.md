Heya KubeAstroNuts!!

 This source code has a react file, docker file, yaml file and terraform. 
 The source is quite basic, it has a menu, image and a card layout such that it will display 3 headphone images along with the name and price. Eventually will make it better or any other source code is also appreciated.

Firstly I used VS code. Make a folder for this project and open Vs code File -> Select folder (select the one you created) and open terminal (shift ~). 

Do: git clone https://github.com/Grp4-Kubestronauts/Ecomm.git and all the code will be downloaded. 

Remember to cd to Ecomm and proceed with: npm install (This should install all the necessary libraries that we used for the react js source code).

Do npm start to check if the app opened up in your browser (if not then there are errors, ChatGPT it)

Now the terminal u are running is powershell create a new terminal with git bash 

You should see a $ sign now else none of the below commands will work.

cd Ecomm/terraform 

terraform init (this will setup terraform essentials in your folder)

terraform plan (This will show what files are updated, optional, just for info)

terraform apply -auto-approve (This is the creation part where your ECR, EKS, Node group and all the amazon service will be created. This should takes 10- 25 mins.)

Once this is done, EKS cluster is created in Ohio region (us-east-2). Remember from this minute onwards you will be charged $$$ not much.

Remember to open your Docker app and leave it there.

**cd ../
./deploy.sh **(This is a script that puts a list of commands on its own and in the end if all goes good it should give you a AWS URL link where our site will be hosted with kubernetes)

Congrats! though we got more to do in it.
