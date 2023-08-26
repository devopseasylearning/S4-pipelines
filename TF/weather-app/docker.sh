#!/bin/bash

################## DEPLOY THE APP
sudo docker rm -f $(docker ps -aq) || true 
sudo docker rmi -f $(docker images -aq) || true 
sudo docker system prune -fa || true
sudo docker-compose up -d 

sleep 5

sudo docker-compose ps 
