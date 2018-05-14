Set-Location ..

$commit=(git rev-parse HEAD).Substring(0,8)
$branch=git rev-parse --abbrev-ref HEAD

Write-Host "> Make app."

docker run --rm -v ${PWD}:/go/src/app -w /go/src/app circleci/golang:1.10.2 make

Write-Host "> Build and push to docekr hub."

docker build -t dominatcorp/tgbot:"$commit"."$branch" -t dominatcorp/tgbot:latest ./artifact
docker push dominatcorp/tgbot:"$commit"."$branch"
docker push dominatcorp/tgbot:latest

$server=$args[1] + "@" + $args[0]

Write-Host "> Pull on" $server "key" $args[2] "."

plink -ssh -i $args[2] $server 'docker pull dominatcorp/tgbot:latest'
plink -ssh -i $args[2] $server 'docker stop tgbot || true'
plink -ssh -i $args[2] $server 'docker run --name tgbot --rm -d -p 8988:8988 --env-file /e/tgbot dominatcorp/tgbot:latest'

Write-Host "> Done."