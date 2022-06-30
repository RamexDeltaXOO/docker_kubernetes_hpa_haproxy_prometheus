#!/bin/bash
echo Vegeta Install
# Retrieve the latest version tag of Vegeta release and assign it to variable.

VEGETA_VERSION=$(curl -s "https://api.github.com/repos/tsenart/vegeta/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')

# download tar.gz file from releases page of the Vegeta repository

curl -Lo vegeta.tar.gz "https://github.com/tsenart/vegeta/releases/latest/download/vegeta_${VEGETA_VERSION}_linux_amd64.tar.gz"

# Create temporary directory and extract a tar.gz file

mkdir vegeta-temp
tar xf vegeta.tar.gz -C vegeta-temp

# Next, move executable file to /usr/local/bin directory.

 mv vegeta-temp/vegeta /usr/local/bin

# Check if vegeta is correctly installed

vegeta --version

