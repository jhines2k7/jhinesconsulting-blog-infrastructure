#!/bin/bash

failed_installs_file="./failed_installs.txt"

function get_ip {
    echo $(docker-machine ip $1)
}

function get_manager_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'manager')
}

#create manager node
function create_manager_node {
    bash ./create-node.sh manager 1 $ENV $PROVIDER

    result=$?

    if [ $result -ne 0 ]
    then
        echo "There was an error installing docker on the manager node. The script will now exit."
        
        echo "=====> Cleaning up..."

        bash ./remove-all-nodes.sh

        exit 1   
    fi
}

function set_manager_node_env_variables {
    ./runremote.sh \
       ./set-manager-env-variables.sh \
       $(get_manager_machine_name)  \
       "$DOCKER_HUB_USER" \
       "$DOCKER_HUB_PASSWORD"
}

function init_swarm_manager {
    # initialize swarm mode and create a manager
    echo "======> Initializing swarm manager ..."
    
    local manager_machine=$(get_manager_machine_name)
    local ip=$(docker-machine ip $manager_machine)

    echo "Swarm manager machine name: $manager_machine"
    docker-machine ssh $manager_machine sudo docker swarm init --advertise-addr $ip
}

function copy_env_file {
    local env_file="../.env"
    local directory=/

    if [ "$PROVIDER" = "aws" ]
    then
        directory=/home/ubuntu
    fi

    echo "======> copying .env file to manager node ..."

    docker-machine scp $env_file $(get_manager_machine_name):$directory
}

function copy_compose_file {
    local docker_file="../jhines-consulting-blog.yml"

    if [ "$ENV" = "dev" ]
    then
        docker_file="../jhines-consulting-blog.dev.yml"
    fi

    if [ "$ENV" = "test" ]
    then
        docker_file="../jhines-consulting-blog.test.yml"
    fi

    echo "======> copying compose file to manager node ..."
    
    docker-machine scp $docker_file $(get_manager_machine_name):$directory
}

function create_512mb_worker_nodes {
    local num_nodes=$1

    echo "======> creating 512mb worker nodes"
    
    bash ./create-node.sh 512mb $num_nodes $ENV $PROVIDER
}

> $failed_installs_file

bash ./remove-all-nodes.sh

create_manager_node
init_swarm_manager
copy_compose_file

echo "======> creating blog node..."
create_512mb_worker_nodes 1 &
echo "======> finished creating blog node..."

bash ./remove-nodes-with-failed-docker-installations.sh

set_manager_node_env_variables

docker-machine ls
