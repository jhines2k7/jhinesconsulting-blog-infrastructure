#!/bin/bash

#remove all nodes
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'jhcmanager\|jhc512mb\|jhcblog\|jhcmock\|jhccontactsdb\|jhckafka\|jhcprojects\|list\|jhccreate\|jhcui\|jhccontact');
    do docker-machine rm -f $machine;
done