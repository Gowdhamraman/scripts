#!/bin/bash

# Update the system package list
echo "Updating package list..."
sudo apt update

# Install Python prerequisites
echo "Installing Python and required packages..."
sudo apt install -y python3 python3-pip python3-apt

# Install software-properties-common (for managing repositories)
echo "Installing software-properties-common..."
sudo apt install -y software-properties-common

# Add Ansible PPA (Personal Package Archive)
echo "Adding Ansible PPA repository..."
sudo apt-add-repository --yes --update ppa:ansible/ansible

# Install Ansible
echo "Installing Ansible..."
sudo apt install -y ansible

# Create /etc/ansible directory if it doesn't exist
echo "Creating /etc/ansible directory..."
sudo mkdir -p /etc/ansible

# Create ansible.cfg file with default settings
echo "Creating ansible.cfg with default configuration..."
sudo tee /etc/ansible/ansible.cfg > /dev/null <<EOL
[defaults]
inventory = /etc/ansible/hosts
remote_user = root
host_key_checking = False
EOL

# Final message
echo "Ansible installation completed and ansible.cfg created in /etc/ansible."
