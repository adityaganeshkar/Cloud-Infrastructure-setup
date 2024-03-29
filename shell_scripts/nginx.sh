#!/bin/bash

# Update package index
sudo apt-get update

# Install Nginx
sudo yum install nginx -y

# Start Nginx service
sudo systemctl start nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx

# Display status message
echo "Nginx has been installed and started. You can access it at http://localhost/"

# Install Java 17
sudo yum install openjdk-17-jdk -y
