#!/usr/bin/env bash

manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'manager')

docker_file="jhines-consulting-blog.yml"
directory=/

if [ "$ENV" = "dev" ]
then
    docker_file="jhines-consulting-blog.dev.yml"
fi

if [ "$ENV" = "test" ]
then
    docker_file="jhines-consulting-blog.test.yml"
fi

docker-machine ssh $manager_machine sudo docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD

docker-machine ssh $manager_machine \
    sudo docker stack deploy \
    --compose-file /home/ubuntu/$docker_file \
    --with-registry-auth \
    integration
