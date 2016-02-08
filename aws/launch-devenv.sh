#!/bin/bash

IP=$(curl http://checkip.amazonaws.com);
aws ec2 create-security-group --group-name alsl-ec2-dev-sg --description "Security group for developer instances"


aws ec2 describe-security-groups --group-names alsl-ec2-dev-sg --query SecurityGroups[0].IpPermissions > tmp.json

aws ec2 revoke-security-group-ingress --group-name alsl-ec2-dev-sg --ip-permissions file://tmp.json

rm tmp.json

aws ec2 authorize-security-group-ingress --group-name alsl-ec2-dev-sg --protocol tcp --port 22 --cidr $IP/32

aws ec2 run-instances --image-id ami-9abea4fb --key-name $USER --security-groups alsl-ec2-dev-sg --instance-type t2.micro  --iam-instance-profile Name=alsl-ec2-dev --user-data file://userdata.sh
