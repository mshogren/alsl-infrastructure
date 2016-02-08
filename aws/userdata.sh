#!/bin/bash -ex

# Debian apt-get install function
apt_get_install()
{
    DEBIAN_FRONTEND=noninteractive apt-get -y \
                    -o DPkg::Options::=--force-confdef \
                    -o DPkg::Options::=--force-confold \
                    install $@
}
         
# Some initial setup
set -e -x
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get upgrade -y
         
# Install required packages
apt_get_install git ansible 

# Run ansible
ansible-pull -i "localhost," -d /home/ubuntu/alsl-infrastructure -U https://github.com/mshogren/alsl-infrastructure aws/alsl-ec2-dev.yml
