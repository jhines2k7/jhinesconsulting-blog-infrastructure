#!/usr/bin/env bash
worker_machine=$1

function get_manager_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'jhcmanager')
}

function get_ip {
    local manager_machine=$1
    echo $(docker-machine ip $manager_machine)
}

function get_worker_token {
    local manager_machine=$(get_manager_machine_name)
    # gets swarm manager token for a worker node
    echo $(docker-machine ssh $manager_machine sudo docker swarm join-token worker -q)
}

manager_machine=$(get_manager_machine_name)

docker-machine ssh $worker_machine \
sudo docker swarm join \
    --token $(get_worker_token) \
    $(get_ip $manager_machine):2377
