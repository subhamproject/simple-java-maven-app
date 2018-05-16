#!/bin/bash
#cd $(dirname $0)
export pwd=$(pwd)
export PATH="$PATH:/usr/local/bin"
docker-compose run --rm  --entrypoint "mvn clean package" maven-app
