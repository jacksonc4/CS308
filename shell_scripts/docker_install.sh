#!/bin/bash
#Installs and starts Docker-engine

#update packages
sudo apt-get update

#make sure that curl is installed, and get recommended pre-requisites for OS
sudo apt-get install curl \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual

#ensure apt works with https method and that CA certificates are installed
sudo apt-get install apt-transport-https ca-certificates

#add official docker GPG encryption key
curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -

#verify the correct key ID is 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D

#Set up the stable docker repository
sudo add-apt-repository "deb https://apt.dockerproject.org/repo/ ubuntu-$(lsb_release -cs) main"

#update packages again and install docker-engine
sudo apt-get update
sudo apt-get -y install docker-engine

#Download the Docker Machine binary and extract it to your file path
curl -L https://github.com/docker/machine/releases/download/v0.9.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
  chmod +x /tmp/docker-machine &&
  sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

#Check the installation by displaying the Machine version
sudo docker-machine version
