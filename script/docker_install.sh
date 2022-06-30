#!/bin/bash

sudo -s
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
echo "Your username : "
read username
usermod -aG docker $username