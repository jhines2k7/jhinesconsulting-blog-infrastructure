#!/bin/bash

#remove all nodes
for machine in $(docker-machine ls --format "{{.Name}}" | grep 'jhc_manager\|jhc_512mb\|jhc_blog\|jhc_mock\|contact\|jhc_kafka\|jhc_projects\|list\|jhc_create\|jhc_ui');
    do docker-machine rm -f $machine;
done