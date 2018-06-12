#!/bin/bash -ex
# Based on http://blog.xi-group.com/2014/07/small-tip-how-to-use-aws-cli-to-start-spot-instances-with-userdata/

wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent

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

sudo apt-add-repository ppa:ansible/ansible

apt-get update && apt-get upgrade -y

# Install required packages
apt_get_install git ansible

# Install nvm
su - ubuntu -c "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | PROFILE=~/.profile bash"

# Run ansible
su - ubuntu -c "ansible-pull -i /home/ubuntu/alsl-infrastructure/aws/hosts.yml -d /home/ubuntu/alsl-infrastructure -U git@github.com:mshogren/alsl-infrastructure.git aws/alsl-ec2-dev.yml"
