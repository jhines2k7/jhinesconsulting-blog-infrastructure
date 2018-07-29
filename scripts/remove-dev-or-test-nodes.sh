#!/usr/bin/env bash

#remove all dev or test nodes
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'dev\|test');
    do docker-machine rm -f $machine;
done