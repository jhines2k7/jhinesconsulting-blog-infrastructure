#!/usr/bin/env bash

manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'manager')

docker_file="export-data-from-occasion-to-mysql-service.yml"
directory=/
env_file=".env"

if [ "$PROVIDER" = "aws" ] && [ "$ENV" = "dev" ]
then
    directory=/home/ubuntu/
    docker_file="export-data-from-occasion-to-mysql-service.dev.yml"
fi

if [ "$PROVIDER" = "aws" ] && [ "$ENV" = "test" ]
then
    directory=/home/ubuntu/
    docker_file="export-data-from-occasion-to-mysql-service.test.yml"
fi

if [ "$PROVIDER" = "aws" ] && ([ "$ENV" = "staging" ] || [ "$ENV" = "prod" ])
then
    directory=/home/ubuntu/
    docker_file="export-data-from-occasion-to-mysql-service.aws.yml"
fi

docker-machine ssh $manager_machine sudo docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD

docker-machine ssh $manager_machine \
    sudo docker stack deploy \
    --compose-file $directory$docker_file \
    --with-registry-auth \
    integration
