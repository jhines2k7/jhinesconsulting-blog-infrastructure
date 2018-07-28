#!/usr/bin/env bash

function get_manager_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'jhckafka')
}

manager_machine=$(get_manager_machine_name)

docker-machine ssh $manager_machine