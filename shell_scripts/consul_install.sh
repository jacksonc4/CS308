#!/bin/bash
#Installs consul for service discovery and node monitoring,
#and then creates a new agent for the node.

cd

#updates packages and installs unzip function
sudo apt-get update
sudo apt-get install unzip

#switch to bin directory and get .zip for consul
cd /usr/local/bin
sudo wget https://releases.hashicorp.com/consul/0.7.3/consul_0.7.3_linux_amd64.zip

#unzip downloaded file and remove .zip file
sudo unzip *.zip
sudo rm *.zip

#grab user input for host IP
echo ***Input host private IP for consul agent configuration***
read instance_IP

#initialize consul agent on node
sudo consul agent -server -data-dir="/tmp/consul" -bootstrap -advertise=$instance_IP -http-port=8500 -client=0.0.0.0 &
