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
    
  2. **Consul** which has the following ports opened:
    * TCP port 8300 for agent communication
    * TCP port 8500 for agent communication
    
  3. **Docker** which has the following ports opened:
    * TCP port 2375 for docker REST API 
    * TCP port 2377 for cluster management communications
    * TCP and UDP ports 4789 for overlay network traffic
    * TCP and UDP ports 7946 for node communications
    * (optional) TCP port 50 for encrypted overlay networks using [--opt encrypted]

  4. **Redis** which has the following ports opened:
    * TCP and UDP port 6379 for Redis server connection
    * TCP and UDP port 16379 for running Redis in cluster mode
    
  5. **Cassandra** which has the following ports opened:
    * TCP port 7000 for cluster node communications
    * TCP port 7001 for SSL internode cluster communications
    * TCP port 7199 for JMX monitoring (node status)
    * TCP port 9042 for CQL native transport
    * TCP port 9162 for Thrift client API
    
2. Create your nodes on AWS and distribute them among the different Availability Zones evenly (i.e. node1 in US-east-1a, node2 in US-east-1b, node3 in US-east-1c). We use nine nodes in our testing, so each of the three master nodes has two workers under it.
  * In the Security Groups tab of instance creation, set the General, Docker, and Redis rules as the groups for each node.

3. In your AWS EC2 console, set the name of one instance in each Availability Zone to Master to differentiate between the permission levels we will set later (an odd number of master nodes is recommended, 3 being ideal).
  * Go back to the Security Groups tab and add the Cassandra and Consul rules to each Master node.
  
4. SSH into each of your instances and clone this repository into a new folder in the /usr/local/bin directory.
  ```
  cd /usr/local/bin
  sudo mkdir CS308
  cd CS308
  sudo git clone https://github.com/jacksonc4/CS308.git .

  ```
  
5. Change the directory to the newly created shell scripts folder. Make sure that the docker_install and consul_install scripts are present.
  ```
  cd /shell_scripts
  ls
  consul_install.sh docker_install.sh
  ```
  
6. Change the properties of the script files to executable, and then run the docker_install script on each node.
  ```
  sudo chmod +x ./consul_install.sh
  sudo chmod +x ./docker_install.sh
  ./docker_install.sh
  ```
  
7. Skip this for now, a Docker image for Consul is pulled from Docker hub in the Docker installation script which is easier to work with. ~~Once Docker has finished installing, go back to the scripts folder and execute the consul_install script on your Master nodes. To create the consul agent, you will need to input the private IP address of your AWS instance.
  ~```
  cd /usr/local/bin/CS308/shell_scripts
  ./consul_install.sh
  <input IP address>
  ~```
  
8. ~~Once Consul has finished installing, edit the Docker Upstart file in the /etc/default directory and add the following setting to the 'DOCKER_OPTS' variable (do this on every node).
  ```
  sudo vi /etc/default/docker
  "-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=consul://<ip-of-consul-host>:8500/network --cluster-advertise=<this-nodes-private-ip>:2376"
  'esc' + ':x" + 'enter' to save and exit.
  ```~~
  
9. For testing simplicity, we will use the Docker swarm commands for now. ~~Once you have added the DOCKER_OPTS setting, restart the Docker daemon and start a primary swarm manager on your primary Master node.
  ```
  sudo service docker restart
  ```
  Run this on your primary Master node:
  ```
  sudo docker run -d -p 4000:4000 --restart=always swarm --experimental manage -H :4000 --replication --advertise <MasterX_ip>:4000 consul://<consul_agent_ip>:8500
  ```
  Then run this on however many alternate Master nodes your cluster has:
  ```
  sudo docker run -d -p 4000:4000 --restart=always swarm --experimental manage -H :4000 --replication --advertise <manager(X+1)_ip>:4000 consul://<consul_agent_ip>:8500
  ```
  Finally, run this command on each node that will be participating in the swarm:
  ```
  sudo docker run -d swarm --experimental join --advertise=<node_ip>:2375 consul://<consul_agent_ip>:8500
  ```~~
