#!/bin/bash

# # Update the apt package index and install dependencies
# sudo apt-get update
# sudo apt-get install -y \
#     apt-transport-https \
#     ca-certificates \
#     curl \
#     gnupg \
#     lsb-release

# # Add Docker’s official GPG key
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# # Use the following command to set up the stable repository
# sudo add-apt-repository -y \
#    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#    $(lsb_release -cs) \
#    stable"

# # Install Docker Engine
# sudo apt-get update
# sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# # Add user to docker group (to run Docker commands as a non-root user)
# sudo usermod -aG docker $USER

# # Install Docker Compose
# sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose


################## DEPLOY THE APP
sudo docker rm -f $(docker ps -aq) || true 
sudo docker rmi -f $(docker images -aq) || true 
sudo docker system prune -fa || true
sudo docker-compose up -d 

sleep 5

sudo docker-compose ps 
