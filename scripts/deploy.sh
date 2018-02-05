#!/usr/bin/env bash

manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'manager')

blog_compose_file="blog.yml"
kafka_compose_file="kafka-service.yml"
http_source_compose_file="http-source-task.yml"

if [ "$ENV" = "dev" ]
then
    kafka_file="kafka-service.dev.yml"
fi

docker-machine ssh $manager_machine sudo docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD

merged_compose_file="docker-stack.yml"

echo "======> running compose config to create a merged compose file"
docker-machine ssh $manager_machine sudo docker-compose \
    -f /home/ubuntu/$kafka_compose_file \
    -f /home/ubuntu/$http_source_compose_file config \
    > /home/ubuntu/$merged_compose_file

echo "======> contents of the merged compose file"
docker-machine ssh $manager_machine cat /home/ubuntu/$merged_compose_file

docker-machine ssh $manager_machine \
    sudo docker stack deploy \
    --compose-file /home/ubuntu/$merged_compose_file \
    --with-registry-auth \
    blog
