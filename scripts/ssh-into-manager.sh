#!/usr/bin/env bash

function get_manager_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'jhcmanager')
}

manager_machine=$(get_manager_machine_name)

docker-machine ssh $manager_machine