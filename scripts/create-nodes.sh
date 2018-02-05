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
    bash ./create-node.sh manager 1

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
    local kafka_host="kafka"
    local zookeeper_host="zookeeper"

    if [ "$ENV" = "dev" ]
    then
        kafka_machine_ip=$(get_ip $(docker-machine ls --format "{{.Name}}" | grep 'kafka'))

        kafka_host=$kafka_machine_ip
        zookeeper_host=$kafka_machine_ip
    fi

    ./runremote.sh \
       ./set-manager-env-variables.sh \
       $(get_manager_machine_name)  \
       "$kafka_host" \
       "$zookeeper_host" \
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
    
    bash ./create-node.sh 512mb $num_nodes
}

function create_blog_node {
    local num_nodes=$1

    echo "======> creating blog worker node"

    bash ./create-node.sh blog $num_nodes

    echo "======> finished creating blog node..."
}

function create_contactformsubmissionservice_node {
    local num_nodes=$1

    echo "======> creating contact form submission service node"

    bash ./create-node.sh contactformsubmissionservice $num_nodes

    echo "======> finished creating contact form submission service node"
}

function create_mock_contact_form_submission_service_node {
    local num_nodes=$1

    echo "======> creating contact form submission service node"

    bash ./create-node.sh mockcontactformsubmissionservice $num_nodes

    echo "======> finished creating contact form submission service node"

    source set-contact-form-service-ip.sh

    source /home/james/projects/jhines-consulting-blog/shell_scripts/build.sh
}

> $failed_installs_file

bash ./remove-all-nodes.sh

create_manager_node
init_swarm_manager
copy_compose_file

create_blog_node 1 &

create_contactformsubmissionservice_node 1 &
wait

bash ./remove-nodes-with-failed-docker-installations.sh

set_manager_node_env_variables

docker-machine ls
