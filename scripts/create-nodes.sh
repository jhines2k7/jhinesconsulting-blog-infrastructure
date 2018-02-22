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
    local contacts_db_host="contactsdb"
    local projects_db_host="projectssdb"

    if [ "$ENV" = "dev" ]
    then
        kafka_machine_ip=$(get_ip $(docker-machine ls --format "{{.Name}}" | grep 'kafka'))
        contacts_db_host=$(get_ip $(docker-machine ls --format "{{.Name}}" | grep 'contactsdb'))
        projects_db_host=$(get_ip $(docker-machine ls --format "{{.Name}}" | grep 'projectsdb'))

        kafka_host=$kafka_machine_ip
        zookeeper_host=$kafka_machine_ip
    fi

    export KAFKA_HOST=$kafka_machine_ip
    export ZOOKEEPER_HOST=$kafka_machine_ip
    export CONTACTS_DB_HOST=$contacts_db_host
    export PROJECTS_DB_HOST=$projects_db_host

    ./runremote.sh \
    ./set-manager-env-variables.sh \
    $(get_manager_machine_name)  \
    "$DOCKER_HUB_USER" \
    "$DOCKER_HUB_PASSWORD" \
    "$JHC_DB_USER" \
    "$JHC_DB_PASS" \
    "$JHC_DB_ROOT_PASS" \
    "$LOGGING_INPUT_CHANNEL" \
    "$kafka_host" \
    "$zookeeper_host" \
    "$contacts_db_host" \
    "$JHC_GMAIL_PASSWORD" \
    "$JHC_GMAIL_ADDRESS" \
    "$projects_db_host"
}

function init_swarm_manager {
    # initialize swarm mode and create a manager
    echo "======> Initializing swarm manager ..."
    
    local manager_machine=$(get_manager_machine_name)
    local ip=$(docker-machine ip $manager_machine)

    echo "Swarm manager machine name: $manager_machine"
    docker-machine ssh $manager_machine sudo docker swarm init --advertise-addr $ip
}

function create_512mb_worker_nodes {
    local num_nodes=$1

    echo "======> creating 512mb worker nodes"
    
    bash ./create-node.sh 512mb $num_nodes
}

function create_blog_ui_node {
    local num_nodes=$1

    echo "======> creating blog worker node"

    bash ./create-node.sh blog-ui $num_nodes

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

function create_contact_form_service_node {
    local num_nodes=$1

    echo "======> creating contact form submission service node"

    bash ./create-node.sh contactformservice $num_nodes

    echo "======> finished creating contact form submission service node"
}

function create_contacts_db_node {
    echo "======> creating mysql contacts worker node"

    bash ./create-node.sh contactsdb 1

    result=$?

    if [ $result -ne 0 ]
    then
        exit 1
    fi
}

function create_projects_db_node {
    echo "======> creating mysql projects worker node"

    bash ./create-node.sh projectsdb 1

    result=$?

    if [ $result -ne 0 ]
    then
        exit 1
    fi
}

function create_contact_request_handler_node {
    echo "======> creating contact request handler node"

    bash ./create-node.sh contactrequesthandler 1

    result=$?

    if [ "$BUILD_UI" = true ] ; then
        source set-contact-request-handler-ip.sh

        source /home/james/projects/jhines-consulting-blog/shell_scripts/build.sh
    fi
}

> $failed_installs_file

bash ./remove-all-nodes.sh

create_manager_node
init_swarm_manager

echo "======> creating kafka and mysql nodes ..."
create_kafka_node &
create_contacts_db_node &
create_projects_db_node &

wait %1
create_kafka_result=$?

wait %2
create_projects_db_result=$?

#wait %3
#create_contacts_db_result=$?

if [ $create_kafka_result -ne 0 ] || [ $create_projects_db_result -ne 0 ]
#if [ $create_kafka_result -ne 0 ] || [ $create_contacts_db_result -ne 0 ] || [ $create_projects_db_result -ne 0 ]
then
    echo "There was an error installing docker on the mysql or kafka nodes. The script will now exit."

    echo "=====> Cleaning up..."

    bash ./remove-all-nodes.sh

    exit 1
fi
echo "======> finished creating kafka and mysql nodes ..."

#create_contact_form_service_node 1 &
#create_contact_request_handler_node &
#create_blog_ui_node 1 &

bash ./create-node.sh createprojectservice 1 &
bash ./create-node.sh listprojectsservice 1 &

wait

bash ./remove-nodes-with-failed-docker-installations.sh

set_manager_node_env_variables

cd /home/james/projects/jhines-consulting-blog-docker/scripts

docker-machine ls
