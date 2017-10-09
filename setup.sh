#/bin/bash

mkdir ~/sky
sudo chmod 1000:1000 ~/sky

cd client
npm i
npm run build
cd -

docker-compose build
docker-compose up -d
