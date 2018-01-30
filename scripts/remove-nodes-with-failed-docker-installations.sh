#!/bin/bash

failed_installs_file="./failed_installs.txt"

if [[ -s $failed_installs_file ]] ; then
    echo "======> removing machines with failed docker installations ..."

    while read machine || [[ -n $machine ]] ; do
        docker-machine rm -f $machine
    done < $failed_installs_file

    > $failed_installs_file
else
    echo "======> there were no machines with failed docker installations ..."
fi ;
