#!/bin/bash

#remove all nodes
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'manager\|mysql\|kafka\|512mb\|1gb\|save');
    do docker-machine rm -f $machine;
done