#!/bin/bash

#remove all nodes
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'manager\|512mb\|blog\|mock\|contact\|kafka\|projects\|list\|create\|ui');
    do docker-machine rm -f $machine;
done