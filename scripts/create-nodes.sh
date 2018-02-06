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

    export KAFKA_HOST=$kafka_host
    export ZOOKEEPER_HOST=$zookeeper_host

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
    echo "======> copying compose file to manager node ..."
#    docker-machine scp ../services/docker-stack.yml $(get_manager_machine_name):/home/ubuntu/
    docker-machine scp jhines-consulting-blog.dev.yml $(get_manager_machine_name):/home/ubuntu/
}

function merge_compose_files {
    echo "======> running compose config to create a merged compose file"

    local blog_compose_file="../services/blog/blog.yml"
    local kafka_compose_file="../services/backing-services/kafka-service.yml"
    local http_source_compose_file="../services/contact-form-submission-service/http-source-task/http-source-task.yml"

    if [ "$ENV" = "dev" ]
    then
        kafka_compose_file="../services/backing-services/kafka-service.dev.yml"
    fi

    echo "======> running docker compose to create a merged compose file"
    docker-compose \
    -f $kafka_compose_file config \
    > ../services/docker-stack.yml

    echo "======> contents of the merged compose file"
    cat ../services/docker-stack.yml
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

function create_kafka_node {
    bash ./create-node.sh kafka 1

    result=$?

    if [ $result -ne 0 ]
    then
        exit 1
    fi
}

function create_contactformsubmissionservice_node {
    local num_nodes=$1

    echo "======> creating contact form submission service node"

    bash ./create-node.sh contactformsubmissionservice $num_nodes

    echo "======> finished creating contact form submission service node"
}

> $failed_installs_file

bash ./remove-all-nodes.sh

create_manager_node
init_swarm_manager

echo "======> creating kafka node ..."
create_kafka_node

create_kafka_result=$?

if [ $create_kafka_result -ne 0 ]
then
    echo "There was an error installing docker on the kafka node. The script will now exit."

    echo "=====> Cleaning up..."

    bash ./remove-all-nodes.sh

    exit 1
fi
echo "======> finished creating kafka node ..."

#create_blog_node 1 &
#wait

#create_contactformsubmissionservice_node 1

bash ./remove-nodes-with-failed-docker-installations.sh

set_manager_node_env_variables

#merge_compose_files
copy_compose_file

docker-machine ls
