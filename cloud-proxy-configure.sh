#!/bin/bash
sudo apt update
sudo apt install wget curl unzip
cd $HOME

FILE=/usr/local/bin/terraform
if [ -f "$FILE" ]; then
        echo "Terraform is already installed, skipping..."
else 
        echo "Installing Terraform"
        TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
        echo ""
        echo "Terraform Version: $TER_VER"
        echo -e "\n"
        wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
        echo -e "\n"
        unzip terraform_${TER_VER}_linux_amd64.zip

        sudo mv terraform /usr/local/bin/

        rm terraform_${TER_VER}_linux_amd64.zip
        echo "Removed ZIP"

fi

echo -e "\n"
cd $HOME

dir1=$HOME/cloud-proxy
if [ -d "$dir1" ]; then
        echo "Cloud-Proxy seems to be installed... skipping"
else 
        echo "Installing Cloud-Proxy"
        git clone https://github.com/AchocolatechipPancake/cloud-proxy.git 
        cd $HOME/cloud-proxy/
        echo -e "\n\n"
        echo "Installing a the Sha3 dependency"
        echo -e "\n"
        go mod init cloud-proxy
        echo -e "\n"
        go get golang.org/x/crypto/sha3
        echo ""
        go build
        echo -e "\n\n\n\n\n\n"
        echo "Configure secrets.tfvars\nThen Run the following commands:"
        echo "    >sudo ./cloud-proxy -do -count 10 -start-tcp 45555"
        echo "    >terraform init”"
        echo "    >sudo ./cloud-proxy -do -count 10 -start-tcp 45555"
fi

dir2=$HOME/proxy-ng
if [ -d "$dir2" ]; then
        echo "Proxy-ng seems to be installed... skipping"
else 
        echo "Installing Proxy-ng"
        mkdir $HOME/proxy-ng
        cd $HOME/proxy-ng/
        wget https://github.com/jamesbcook/proxy-ng/releases/download/0.2.0/proxy-ng-linux
        wget https://raw.githubusercontent.com/jamesbcook/proxy-ng/master/socks5-proxies.json
        wget https://raw.githubusercontent.com/jamesbcook/proxy-ng/master/useragents.json
        mv proxy-ng-linux proxy-ng
        chmod +x proxy-ng
        cd $HOME
fi
cd $HOME/cloud-proxy

timeout 1 ./cloud-proxy -do -count 10
terraform init

echo -e "\n\n\nDONE!"
echo "Enter Keys into $HOME/cloud-proxy/secrets.tfvars"
echo "RUN --> ./cloud-proxy -do -count 10"
