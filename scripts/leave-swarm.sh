#!/usr/bin/env bash

worker_machine=$1

docker-machine ssh $worker_machine \
    sudo docker swarm leave
