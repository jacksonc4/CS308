# CS308 VCU Capstone Project

## Active/Active Cloud Infrastructure 
All of the necessary files can be downloaded from https://github.com/jacksonc4/CS308.git

Group members
---
Curtis Jackson 

Charles Bradshaw 

Edwin Lobo

Description
---

The files in this repository will set up essential utilities on your AWS instances for an intercommunicating cluster of AWS nodes. 

Back-end Setup
---
>  **Note:** An odd number of AWS instances is recommended for this setup to maintain a quorum number of nodes.

1. Create your nodes on AWS and distribute them among the different Availability Zones evenly (i.e. node1 in US-east-1a, node2 in US-east-1b, node3 in US-east-1c). We use nine nodes in our testing.

2. In your AWS EC2 console, set the name one instance in each Availability Zone to 'Master' to differentiate between the permission levels we will set later.

3. Under the 'Security Groups' tab, create the following new rules:

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

