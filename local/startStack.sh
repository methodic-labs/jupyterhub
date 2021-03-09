#!/usr/bin/env bash

. setEnv.sh

./stopStack.sh

docker network create "$DOCKER_NETWORK_NAME"; docker-compose build; docker-compose up -d;
