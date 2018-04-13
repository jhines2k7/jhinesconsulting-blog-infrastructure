#!/bin/bash

#remove all but mysql node
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'jhcmanager\|jhc512mb\|jhcblog\|jhcmock\|jhckafka\|jhccontact\|jhcform\|jhcdb');
    do docker-machine rm -f $machine; 
done
