#!/bin/sh

COMMIT=$(git rev-parse HEAD | cut -c1-8)
BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "make app"

docker run --rm -v "$(pwd)":/go/src/app -w /go/src/app circleci/golang:1.10.2 make

echo "build and push to docekr hub"

docker build -t dominatcorp/tgbot:"$COMMIT"."$BRANCH" -t dominatcorp/tgbot:latest ./artifact
docker push dominatcorp/tgbot:"$COMMIT"."$BRANCH"
docker push dominatcorp/tgbot:latest

echo "pull on server"

ssh root@"$DEPLOY_HOST" 'docker pull dominatcorp/tgbot:latest'
ssh root@"$DEPLOY_HOST" 'docker stop tgbot || true'
ssh root@"$DEPLOY_HOST" 'docker run --name tgbot --rm -d -p 8988:8988 --env-file /e/tgbot dominatcorp/tgbot:latest'

echo "done"