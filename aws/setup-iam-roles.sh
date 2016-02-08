#!/bin/bash

region=$(aws configure get region);
userArn=$(aws iam get-user --query User.Arn);
baseArn=${userArn:1:26};
accountId=${userArn:14:10};

sed -e s/\<region\>/$region/g -e s/\<accountid\>/$accountId/g alsl-ec2-launch-policy.json > tmp.json

aws iam create-user --user-name alsl-ec2-launch
aws iam detach-user-policy --user-name alsl-ec2-launch --policy-arn ${baseArn}policy/alsl-ec2-launch
aws iam delete-policy --policy-arn ${baseArn}policy/alsl-ec2-launch
aws iam create-policy --policy-name alsl-ec2-launch --policy-document file://tmp.json
aws iam attach-user-policy --user-name alsl-ec2-launch --policy-arn ${baseArn}policy/alsl-ec2-launch

rm tmp.json

