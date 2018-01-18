#/bin/bash

mkdir ~/sky
sudo chown 1000:1000 ~/sky

cd client
npm i
npm run build
cd -

docker-compose build
docker-compose up -d
