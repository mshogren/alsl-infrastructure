#!/bin/bash

IP=$(curl http://checkip.amazonaws.com);

aws ec2 describe-security-groups --group-names alsl-ec2-dev-sg

EXISTS=$?;

if [ $EXISTS -ne 0 ]; then
  aws ec2 create-security-group --group-name alsl-ec2-dev-sg --description "Security group for developer instances";
fi

aws ec2 describe-security-groups --group-names alsl-ec2-dev-sg --query SecurityGroups[0].IpPermissions > tmp.json

aws ec2 revoke-security-group-ingress --group-name alsl-ec2-dev-sg --ip-permissions file://tmp.json

rm tmp.json

aws ec2 authorize-security-group-ingress --group-name alsl-ec2-dev-sg --protocol tcp --port 22 --cidr $IP/32

USERDATA=$(base64 userdata.sh -w 0)
QUERY="Images[0].{ImageId: ImageId, InstanceType: \`\"m3.medium\"\`, KeyName: \`\"${USER}\"\`, SecurityGroups: [ \`\"alsl-ec2-dev-sg\"\` ], IamInstanceProfile: { Name: \`\"alsl-ec2-dev\"\` }, UserData: \`\"${USERDATA}\"\`, BlockDeviceMappings: BlockDeviceMappings[*] }"

aws ec2 describe-images --image-id ami-079b4e9085609225c --query "$QUERY" > launch.json

sed -i 's/8,/16,/' launch.json
sed -i '/"Encrypted": false,/d' launch.json

NEXTYEAR=$(date -d "next year" -Is)

aws ec2 request-spot-instances --spot-price "0.012" --type "persistent" --valid-until "$NEXTYEAR" --instance-interruption-behavior "stop" --launch-specification file://launch.json

rm launch.json
