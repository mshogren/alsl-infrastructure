#!/bin/bash -ex
# Based on http://blog.xi-group.com/2014/07/small-tip-how-to-use-aws-cli-to-start-spot-instances-with-userdata/

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
apt_get_install git python3-pip

# Install ansible
pip3 install ansible boto3

# Install nvm
su - ubuntu -c "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | PROFILE=~/.profile bash"

# Run ansible
su - ubuntu -c "ansible-pull -e 'ansible_python_interpreter=/usr/bin/python3' -i /home/ubuntu/alsl-infrastructure/aws/hosts.yml -d /home/ubuntu/alsl-infrastructure -U https://github.com/mshogren/alsl-infrastructure.git aws/alsl-ec2-dev.yml"
