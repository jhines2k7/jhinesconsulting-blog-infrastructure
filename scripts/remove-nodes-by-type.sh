#!/bin/bash

node_type=$1

#remove all nodes of a specific type
for machine in $(docker-machine ls --format "{{.Name}}" | grep $node_type);
    do docker-machine rm -f $machine;
done
