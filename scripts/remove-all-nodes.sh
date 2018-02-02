#!/bin/bash

#remove all nodes
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'manager\|512mb\|blog');
    do docker-machine rm -f $machine;
done