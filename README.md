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

  2. **Docker** which has the following ports opened:
    * TCP port 2375 for docker REST API 
    * TCP port 2377 for cluster management communications
    * TCP and UDP ports 4789 for overlay network traffic
    * TCP and UDP ports 7946 for node communications
    * (optional) TCP port 50 for encrypted overlay networks using [--opt encrypted]

  3. **Redis** which has the following ports opened:
    * TCP and UDP port 6379 for Redis server connection
    * TCP and UDP port 16379 for running Redis in cluster mode
    
  4. **Cassandra** which has the following ports opened:
    * TCP port 7000 for cluster node communications
    * TCP port 7001 for SSL internode cluster communications
    * TCP port 7199 for JMX monitoring (node status)
    * TCP port 9042 for CQL native transport
    * TCP port 9162 for Thrift client API
    
2. Create your nodes on AWS and distribute them among the different Availability Zones evenly (i.e. node1 in US-east-1a, node2 in US-east-1b, node3 in US-east-1c). We use nine nodes in our testing, so each of the three master nodes has two workers under it.
  * In the Security Groups tab of instance creation, set the General, Docker, and Redis rules as the groups for each node.

3. In your AWS EC2 console, set the name of one instance in each Availability Zone to Master to differentiate between the permission levels we will set later (an odd number of master nodes is recommended, 3 being ideal).
  * Go back to the Security Groups tab and add the Cassandra rules to each Master node.
  
4. SSH into each of your instances and clone this repository into a new folder in the /usr/local/bin directory.
  ```
  cd /usr/local/bin
  sudo mkdir CS308
  cd CS308
  sudo git clone https://github.com/jacksonc4/CS308.git .

  ```
  
5. Change the properties of the script file to executable, and then run the docker_install script on each node.
  ```
  cd /shell_scripts
  sudo chmod +x ./docker_install.sh
  ./docker_install.sh
  ```
 
 
###Docker Swarm Set-up
 ---
Now that Docker Engine has been set up on each of your nodes, it is time to create a swarm to network them together.
