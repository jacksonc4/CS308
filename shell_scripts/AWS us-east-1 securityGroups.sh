#!/bin/bash

#Creates necessary AWS Security Groups in us-east-1

#Set up general rules
aws ec2 --region us-east-1 create-security-group --group-name General --description “Standard access ports“
  aws ec2 --region us-east-1 authorize-security-group-ingress --group-name General --protocol tcp --port 80 --cidr 0.0.0.0/0
  aws ec2 --region us-east-1 authorize-security-group-ingress --group-name General --protocol tcp --port 22 --cidr 0.0.0.0/0

#Sets up Cassandra rules
aws ec2 --region us-east-1 create-security-group --group-name Cassandra --description “Cassandra communication ports“
  aws ec2 --region us-east-1 authorize-security-group-ingress --group-name Cassandra --protocol tcp --port 9162 --cidr 0.0.0.0/0
  aws ec2 --region us-east-1 authorize-security-group-ingress --group-name Cassandra --protocol tcp --port 9042 --cidr 0.0.0.0/0
  aws ec2 --region us-east-1 authorize-security-group-ingress --group-name Cassandra --protocol tcp --port 7199 --cidr 0.0.0.0/0
  aws ec2 --region us-east-1 authorize-security-group-ingress --group-name Cassandra --protocol tcp --port 7001 --cidr 0.0.0.0/0
  aws ec2 --region us-east-1 authorize-security-group-ingress --group-name Cassandra --protocol tcp --port 7000 --cidr 0.0.0.0/0
  aws ec2 --region us-east-1 authorize-security-group-ingress --group-name Cassandra --protocol tcp --port 1024-65355 --cidr 0.0.0.0/0

#Sets up Redis Rules
aws ec2 --region us-east-1 create-security-group --group-name Redis --description “Redis communications ports“
  aws ec2 --region us-east-1 authorize-security-group-ingress --group-name Redis --protocol tcp --port 22122 --cidr 0.0.0.0/0
  aws ec2 --region us-east-1 authorize-security-group-ingress --group-name Redis --protocol tcp --port 16379 --cidr 0.0.0.0/0
  aws ec2 --region us-east-1 authorize-security-group-ingress --group-name Redis --protocol tcp --port 6379 --cidr 0.0.0.0/0
