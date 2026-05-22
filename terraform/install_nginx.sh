#!/bin/bash

# Install Nginx
sudo apt update
sudo apt install -y nginx
# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

echo "<h1>Nginx installation completed.</h1>" | sudo tee /var/www/html/index.html