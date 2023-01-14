#!/bin/bash

api_key=$1

if [ -z "$api_key" ]; then
    echo You must supply gala api key!
    exit 1
fi


##### install docker #####
me=$(whoami)

IS_DOCKER_INSTALLED=0
check_if_docker_installed () {
  docker ps > /dev/null 2>&1
  return_code=$?
  if [ $return_code -eq 0 ]
  then
    echo Docker is already installed on you machine
    IS_DOCKER_INSTALLED=1
  fi
}


install_docker () {
  # Install docker
  curl -sSL https://get.docker.com | sh
  install_rc=$?
  if [ $install_rc -ne 0 ];
  then
    echo Could not install docker properly from official script!
    return
  fi

  # start docker service
  sudo systemctl start docker

  if [ $me == 'root' ];
  then
    echo Installed docker as a root user
    return
  fi

  # Run docker as non-root user
  sudo usermod -aG docker $me


  # Check if docker works for a non root user
  docker ps > /dev/null 2>&1
  return_code=$?
  if [ $return_code -ne 0 ];
  then
    # execute in another shell
    sudo su $me -c 'docker ps > /dev/null 2>&1'
    return_code=$?
    if [ $return_code -eq 0 ];
    then
      echo Successfully installed docker as a non rot user
    else
      echo Failed installing docker or setting up it as a noon root user!
    fi
  fi
}


check_if_docker_installed

if [ $IS_DOCKER_INSTALLED -ne 1 ]; then
  install_docker
fi


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
