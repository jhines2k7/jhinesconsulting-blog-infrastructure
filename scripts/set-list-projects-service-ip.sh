#!/usr/bin/env bash

function get_list_projects_service_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'listprojectsservice')
}

machine=$(get_list_projects_service_machine_name)

export LIST_PROJECTS_SERVICE_IP=$(docker-machine ip $machine):3002