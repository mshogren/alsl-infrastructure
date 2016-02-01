#!/bin/bash

userArn=$(aws iam get-user --query User.Arn);
baseArn=${userArn:1:26};

aws iam create-user --user-name alsl-ec2-launch
aws iam detach-user-policy --user-name alsl-ec2-launch --policy-arn ${baseArn}policy/alsl-ec2-launch
aws iam delete-policy --policy-arn ${baseArn}policy/alsl-ec2-launch
aws iam create-policy --policy-name alsl-ec2-launch --policy-document file://alsl-ec2-launch-policy.json
aws iam attach-user-policy --user-name alsl-ec2-launch --policy-arn ${baseArn}policy/alsl-ec2-launch
