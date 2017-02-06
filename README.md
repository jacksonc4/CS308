# CS308 VCU Capstone Project

## Active/Active Cloud Infrastructure 
The cloud platform for this project is Amazon Web Services (https://aws.amazon.com). All of the necessary project files can be downloaded from https://github.com/jacksonc4/CS308.git

Group members
---
Curtis Jackson 

Charles Bradshaw 

Edwin Lobo

Description
---

The files in this repository will set up essential utilities on your AWS instances for an intercommunicating cluster of AWS nodes. 

Service Set-up
---
>  **Note:** An odd number of AWS instances is recommended for this setup to maintain a quorum number of nodes.

1. Under the 'Security Groups' tab, create the following new rules:

  1. **General** which has the following ports opened:
    * TCP port 22 for SSH
    * TCP port 80 for HTTPS

  2. **Docker (skip this for now)** which has the following ports opened:
    * TCP port 2375 for docker REST API 
    * TCP port 2377 for cluster management communications
    * TCP and UDP ports 4789 for overlay network traffic
    * TCP and UDP ports 7946 for node communications
    * (optional) TCP port 50 for encrypted overlay networks using [--opt encrypted]

  4. **Cassandra** which has the following ports opened:
    * TCP port range 1024 - 65355 (required for JMX)
    * TCP port 7000 for cluster node communications
    * TCP port 7001 for SSL internode cluster communications
    * TCP port 7199 for JMX monitoring (node status)
    * TCP port 9042 for CQL native transport
    * TCP port 9162 for Thrift client API
    
2. Create your nodes on AWS using the Ubuntu 16.04 AMI and distribute them among the different Availability Zones to see how different regions interact (i.e. node1 in US-east-1a, node2 in US-east-1b, node3 in US-east-1c). Cassandra required m3.medium AWS instance types at minimum to run properly in our testing.
  * In the Security Groups tab of instance creation, set the General and Cassandra rules as the groups for each node.
  
3. SSH into each of your instances and clone this repository into a new folder in the /usr/local/bin directory.
  ```
  cd /usr/local/bin
  sudo mkdir CS308
  cd CS308
  sudo git clone https://github.com/jacksonc4/CS308.git .

  ```
  
4. Change the properties of the script files to executable, and then run the cassandra_install script on each node.
  ```
  cd /shell_scripts
  sudo chmod +x ./docker_install.sh (skip for now)
  ./docker_install.sh (skip for now)
  sudo chmod +x ./cassandra_install.sh
  ./cassandra_install.sh
  ```
 
 
###Cassandra Cluster Set-up
 ---
Now that Cassandra has been installed on each of your nodes, the cluster has to be configured to get each node gossiping.

On each node, do the following:

* Point to the Cassandra directory, and look for the cassandra.yaml and cassandra-rackdc.properties files.
  ```
  cd /etc/cassandra/
  ls
  cassandra.yaml  cassandra-rackdc.properties . . .  
  ```
* Use your preferred text editor (vim for us) to edit the following properties in the cassandra.yaml file:
  1. Cluster Name
  2. Listen Address
  3. Broadcast Address
  4. rpc Address
  5. Seeds
  6. Endpoint Snitch
  
* Each of these should be set to the following, depending on the current node:
  1. cluster_name: 'Name does not matter -- but must be the same on every node'
  2. listen_address: privateIP of the current node
  3. broadcast_address: publicIP of the current node
  4. rpc_address: privateIP of the current node
  5. seeds: "publicIPs of each desired seed node -- must have at least one per datacenter, separated by a comma"
  6. endpoint_snitch: Ec2MultiRegionSnitch
  
* Once the settings are properly configured, save the updates and exit from the text editor. Next, edit the cassandra-rackdc.properties file in the same way.
  - On each node, scroll to the bottom and uncomment the line reading 'prefer_local.' Save the update and exit from the text editor.
  
At this point, the node configurations should be properly set. Use the following command to start each node individually (start seeds first).
```
sudo /etc/init.d/cassandra start
```

Once each node has been brought up, verify that the cluster is up and running with
```
nodetool status
```
