#!/bin/bash
#Installs and starts Docker-engine

cd
clear

#update packages
sudo apt-get update

#ensure apt works with https method and that CA certificates are installed
sudo apt-get install apt-transport-https ca-certificates

#add GPG encryption key
sudo apt-key adv -keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

#Create new docker.list file and add the ubuntu-xenial image to it
#Add in the following ubuntu image link for docker to use: 
#deb https://apt.dockerproject.org/repo ubuntu-xenial main
sudo vi /etc/apt/sources.list.d/docker.list

#update packages again
sudo apt-get update 

#purge the old repo if it exists, and verify the cache is pulling
#from the right repository
sudo apt-get purge lxc-docker 
sudo apt-cache policy docker-engine

#install recommended pre-requisites for OS
sudo apt-get install linux-image-extra$(uname -r)

#update packages again and install docker-engine
sudo apt-get update
sudo apt-get install docker-engine

#update packages again and install docker-engine
sudo service docker start