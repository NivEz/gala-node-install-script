#!/bin/bash

api_key=$1

if [ -z "$api_key" ]; then
    echo You must supply gala api key!
    exit 1
fi


##### install docker (via my script) #####
curl -sSL https://raw.githubusercontent.com/NivEz/my-snippets/main/docker-install.sh | sh

##### install gala node v3 #####
mkdir -p ~/gala3-installer
cd ~/gala3-installer

# download gala node software v3 tar file
sudo wget -O gala-node-v3.tar.gz --trust-server-names https://links.gala.com/DownloadLinuxNode

# Extract tar
tar xvf gala-node-v3.tar.gz

# Run install script (as root)
echo yes | sudo ./gala-node/install.sh

# Add API key
sudo gala-node config api-key $api_key

# list of workloads you can run
licenses=$(sudo gala-node licenses)

# Config all workloads to run
for license in $(echo $licenses | tr ", " "\n")
do
  sudo gala-node workload add $license
done

# Start Gala Node
sudo gala-node start
