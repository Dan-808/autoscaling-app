#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

sudo apt-get install -y stress-ng

# sudo stress-ng --cpu 32 --timeout 180 --metrics-brief