#!/bin/bash
#Installs consul for service discovery and node monitoring,
#and then creates a new agent for the node.

cd
clear

sudo apt-get update
sudo apt-get install unzip

cd /usr/local/bin
sudo wget https://releases.hashicorp.com/consul/0.7.3/consul_0.7.3_linux_amd64.zip

sudo unzip *.zip
sudo rm *.zip

sudo echo “Input host IP for consul agent configuration”
sudo read instance_IP

sudo consul agent -server -data-dir="/tmp/consul" -bootstrap -advertise=“$instance_IP” -http-port=8500 -client=0.0.0.0 &