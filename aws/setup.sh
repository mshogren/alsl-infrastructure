#!/bin/bash

aws iam create-user --user-name alsl-ec2-launch
aws iam create-policy --policy-name alsl-ec2-launch --policy-document file://alsl-ec2-launch-policy.json
aws iam attach-user-policy --user-name alsl-ec2-launch --policy-arn 
