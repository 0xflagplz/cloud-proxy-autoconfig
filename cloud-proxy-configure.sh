#!/bin/bash
sudo apt update
sudo apt install wget curl unzip
cd ~/tools/
TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
unzip terraform_${TER_VER}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TER_VER}_linux_amd64.zip
cd $HOME
git clone https://github.com/AchocolatechipPancake/cloud-proxy.git 
cd cloud-proxy
go get golang.org/x/crypto/sha3   
go mod init cloud-proxy     
go build    
echo “Configure secrets.tfvars\nThen Run the following commands:\n”
echo “    >sudo ./cloud-proxy -do -count 10 -start-tcp 45555”
echo “    >terraform init” 
echo “    >sudo ./cloud-proxy -do -count 10 -start-tcp 45555”
