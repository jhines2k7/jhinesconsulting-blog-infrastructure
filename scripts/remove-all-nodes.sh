#!/bin/bash

#remove all nodes
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'prod');
    do docker-machine rm -f $machine;
done