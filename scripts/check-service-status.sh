#!/usr/bin/env bash
manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'jhcmanager')

docker-machine ssh $manager_machine sudo docker service ls
