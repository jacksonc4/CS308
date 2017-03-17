#!/bin/bash
#Verifies that java 8 JRE is installed and installs Apache Cassandra

#Verify java 8 is installed first
sudo add-apt-repository ppa:webupd8team/java

#Update packages
sudo apt-get update

#Installs java 8 JRE and sets it as the default JRE
sudo apt-get install oracle-java8-set-default

#Verify that the right version of java is installed
java -version

#Add the Cassandra 3.9 repository to the package system files
echo "deb http://www.apache.org/dist/cassandra/debian 39x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list

#Gets the Cassandra GPG keys
curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -

#Updates packages
sudo apt-get update

#Installs Cassandra
sudo apt-get install cassandra 

#Stops the Cassandra service so the configuration files may be safely edited
sudo /etc/init.d/cassandra stop

#Clears the default system data to avoid data conflicts
sudo rm -rf /var/lib/cassandra/data/system/*

#Removes the old cassandra-rackdc.properties and cassandra.yaml files
cd /etc/cassandra
sudo rm -rf cassandra-rackdc.properties
sudo rm -rf cassandra.yaml
cd

#Moves the new files into the cassandra folder
cd CS308
sudo mv cassandra-rackdc.properties /etc/cassandra
sudo mv cassandra.yaml /etc/cassandra
