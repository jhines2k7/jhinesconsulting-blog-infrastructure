#!/usr/bin/env bash
manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'jhckafka')

docker-machine ssh $manager_machine sudo docker service ls
