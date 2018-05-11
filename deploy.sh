#!/usr/bin/env bash

echo "Pulling latest version"
ssh root@$HOST 'docker pull dominatcorp/tgbot:latest'
ssh root@$HOST 'docker kill $(docker ps -q)'

echo "Starting..."
ssh root@$HOST 'docker run -d --restart=always -p 8988:8988 dominatcorp/tgbot:latest'

echo "Success!"

exit 0