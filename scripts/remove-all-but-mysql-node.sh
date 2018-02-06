#!/bin/bash

#remove all but mysql node
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'manager\|512mb\|blog\|mock\|kafka');
    do docker-machine rm -f $machine; 
done
