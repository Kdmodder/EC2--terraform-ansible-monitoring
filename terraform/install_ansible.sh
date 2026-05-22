#!/bin/bash

# Update system
sudo apt update -y

# Install Ansible
sudo apt install -y ansible python3-pip

# Install AWS libraries (for future dynamic inventory)
pip3 install boto3 botocore

echo "Ansible installed successfully"

ansible-galaxy collection install amazon.aws