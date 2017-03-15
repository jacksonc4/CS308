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

This repository will guide you through the steps necessary to create and test a multi-regional cluster of AWS nodes running the NoSQL database Cassandra.

Instance Set-up
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
    
2. Choose two or more AWS regions to provision your nodes in, create them using the Ubuntu 16.04 AMI, and distribute them among the different Availability Zones (i.e. node1 in US-east-1a, node2 in US-east-1b, node3 in US-west-2a, etc). Cassandra required m3.medium AWS instance types at minimum to run properly in our testing.
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
 
Cassandra Cluster Set-up
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
The output should look like this:
![Screenshot](cassandra_start_confirmation.png)

If not, then something may have went wrong with installation.

Once each node has been brought up, verify that the cluster is up and running with
```
nodetool status
```
Cluster with seeds booted first:
---
![Screenshot](active_cluster.png)

Cluster with all nodes active:
---
![Screenshot](active_seeds.png)

Cassandra Cluster testing
 ---
Now that the Cassandra cluster has been created, it may be tested using the Cassandra demo code. Before using this, a keyspace called 'demo' must be created.

Use the Cassandra Query Language shell on any node to create the keyspace with the following command: 
```
cqlsh <privateIP of node>
```
This should look like:
![Screenshot](connecting_to_cluster.png)

Now, create the demo keyspace:
```
CREATE KEYSPACE demo WITH replication = {'class':'NetworkTopologyStrategy', '<first DC>':<desired # of replicas>', . . . , '<last DC>':<desired # of replicas>'} AND durable_writes = true;
```
where the DC is the name of the AWS region where you have nodes deployed (i.e. us-west-2), and number of replicas determines how many copies of your data are sent throughout the ring (an odd number > 2 is recommended).

Once the keyspace has been created, grab the demo code from the Cassandra file in this repo. Open the source code of the createDB.java file and edit the following lines of code to suit your needs:
```
  //Change x to be equal to the data volume you wish to send to the cluster
  TextGenerator.createFile(x);
  
  //Change the contatct point to be the public IP of whichever node you wish to connect to
  cluster = Cluster.builder().addContactPoint("public IP").withPort(9042).build();
```

After the code has completed its execution, you may use cqlsh again to verify that the data has been sent to the cluster and distributed throughout the ring (there will be several results to tab through depending on the data volume sent to cluster).
```
cqlsh <public IP of node>
use demo;
select * from users;
```

Use the following command to drop the sample table:
```
drop table users;
```
