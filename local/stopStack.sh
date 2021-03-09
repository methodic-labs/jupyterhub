#!/usr/bin/env bash

. setEnv.sh

docker-compose down --remove-orphans; docker volume rm "$COMPOSE_PROJECT_NAME"_jupyterhub_data; docker network prune -f
