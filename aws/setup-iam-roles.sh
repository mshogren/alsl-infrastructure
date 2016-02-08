#!/bin/bash

region=$(aws configure get region);
userArn=$(aws iam get-user --query User.Arn);
baseArn=${userArn:1:26};
accountId=${userArn:14:12};

sed -e s/\<region\>/$region/g -e s/\<accountid\>/$accountId/g alsl-ec2-launch-policy.json > tmp.json

aws iam create-user --user-name alsl-ec2-launch
aws iam detach-user-policy --user-name alsl-ec2-launch --policy-arn ${baseArn}policy/alsl-ec2-launch
aws iam delete-policy --policy-arn ${baseArn}policy/alsl-ec2-launch
aws iam create-policy --policy-name alsl-ec2-launch --policy-document file://tmp.json
aws iam attach-user-policy --user-name alsl-ec2-launch --policy-arn ${baseArn}policy/alsl-ec2-launch

rm tmp.json

aws iam create-role --role-name alsl-ec2-dev --assume-role-policy-document file://ec2-assume-role-policy.json
aws iam attach-role-policy --role-name alsl-ec2-dev --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
aws iam create-instance-profile --instance-profile-name alsl-ec2-dev
aws iam add-role-to-instance-profile --instance-profile-name alsl-ec2-dev --role-name alsl-ec2-dev

