#/bin/bash

mkdir ~/sky
sudo chmod 1000:1000 ~/sky

docker-compose build
docker-compose up -d
