#!/bin/bash

#General rules
aws ec2 --region us-east-1 authorize-security-group-ingress --group-name ClusterTestEnv --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 --region us-east-1 authorize-security-group-ingress --group-name ClusterTestEnv --protocol tcp --port 22 --cidr 0.0.0.0/0

#Cassandra rules
aws ec2 --region us-east-1 authorize-security-group-ingress --group-name ClusterTestEnv --protocol tcp --port 9162 --cidr 0.0.0.0/0
aws ec2 --region us-east-1 authorize-security-group-ingress --group-name ClusterTestEnv --protocol tcp --port 9042 --cidr 0.0.0.0/0
aws ec2 --region us-east-1 authorize-security-group-ingress --group-name ClusterTestEnv --protocol tcp --port 7199 --cidr 0.0.0.0/0
aws ec2 --region us-east-1 authorize-security-group-ingress --group-name ClusterTestEnv --protocol tcp --port 7001 --cidr 0.0.0.0/0
aws ec2 --region us-east-1 authorize-security-group-ingress --group-name ClusterTestEnv --protocol tcp --port 7000 --cidr 0.0.0.0/0
aws ec2 --region us-east-1 authorize-security-group-ingress --group-name ClusterTestEnv --protocol tcp --port 1024-65355 --cidr 0.0.0.0/0

#Redis rules
aws ec2 --region us-east-1 authorize-security-group-ingress --group-name ClusterTestEnv --protocol tcp --port 22122 --cidr 0.0.0.0/0
aws ec2 --region us-east-1 authorize-security-group-ingress --group-name ClusterTestEnv --protocol tcp --port 16379 --cidr 0.0.0.0/0
aws ec2 --region us-east-1 authorize-security-group-ingress --group-name ClusterTestEnv --protocol tcp --port 6379 --cidr 0.0.0.0/0

echo Rules added.