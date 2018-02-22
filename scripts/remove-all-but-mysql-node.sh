#!/bin/bash

#remove all but mysql node
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'manager\|512mb\|blog\|mock\|kafka\|contact\|form\|list\|create');
    do docker-machine rm -f $machine; 
done
