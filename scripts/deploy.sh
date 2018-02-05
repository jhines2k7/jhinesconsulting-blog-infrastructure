#!/usr/bin/env bash

manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'manager')

kafka_compose_file="kafka-service.yml"
http_source_compose_file="http-source-task.yml"

if [ "$ENV" = "dev" ]
then
    kafka_file="kafka-service.dev.yml"
fi

docker-machine ssh $manager_machine sudo docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD

compose_file="docker-stack.yml"

docker-machine ssh $manager_machine sudo docker-compose \
    -f $kafka_compose_file \
    -f $http_source_compose_file config \
    > /home/ubuntu/$compose_file

docker-machine ssh $manager_machine \
    sudo docker stack deploy \
    --compose-file /home/ubuntu/$compose_file \
    --with-registry-auth \
    blog
