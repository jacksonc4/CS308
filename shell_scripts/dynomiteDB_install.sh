#!/bin/bash

#Installs DynomiteDB on a node
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FB3291D9
sudo add-apt-repository "deb https://apt.dynomitedb.com/ trusty main"
sudo apt-get update
sudo apt-get install -y dynomitedb

cd /etc/dynomitedb
sudo rm -rf dynomite.yaml

cd ~/CS308
sudo mv dynomite.yaml /etc/dynomitedb

echo Installation successful. Update the .yaml file to configure.