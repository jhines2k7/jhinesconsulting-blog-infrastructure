#!/bin/bash

failed_installs_file="./failed_installs.txt"

function get_ip {
    echo $(docker-machine ip $1)
}

function get_manager_machine_name {
    if [ "$ENV" = "prod" ] ; then
        echo $(docker-machine ls --format "{{.Name}}" | grep 'prod-jhckafka')
    elif [ "$ENV" = "dev" ] ; then
        echo $(docker-machine ls --format "{{.Name}}" | grep 'dev-jhckafka')
    else
        echo $(docker-machine ls --format "{{.Name}}" | grep 'test-jhckafka')
    fi
}

function set_manager_node_env_variables {
    local kafka_host="kafka"
    local zookeeper_host="zookeeper"
    local contacts_db_host=$(get_ip $(docker-machine ls --format "{{.Name}}" | grep 'jhccontactsdb'))

    if [ "$ENV" = "dev" ] ; then
        kafka_machine_ip=$(get_ip $(docker-machine ls --format "{{.Name}}" | grep 'dev-jhckafka'))

        kafka_host=$kafka_machine_ip
        zookeeper_host=$kafka_machine_ip
    fi

    export KAFKA_HOST=$kafka_host
    export ZOOKEEPER_HOST=$zookeeper_host
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
    "$projects_db_host" \
    "$PROJECTS_DB_PORT" \
    "$PROJECTS_DB_NAME" \
    "$CONTACTS_DB_PORT" \
    "$CONTACTS_DB_NAME" \
    "$KEYSTORE_PASSWORD"
}

function init_swarm_manager {
    # initialize swarm mode and create a manager
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

    bash ./create-node.sh jhcui $num_nodes

    echo "======> finished creating blog node..."
}

function create_kafka_node {
    bash ./create-node.sh jhckafka 1

    result=$?

    if [ $result -ne 0 ] ; then
        exit 1
    fi
}

function create_contact_form_service_node {
    local num_nodes=$1

    echo "======> creating contact form service node"

    bash ./create-node.sh jhccontactformservice $num_nodes

    echo "======> finished creating contact form service node"
}

function create_contacts_db_node {
    echo "======> creating mysql contacts worker node"

    bash ./create-node.sh jhccontactsdb 1

    result=$?

    if [ $result -ne 0 ] ; then
        exit 1
    fi
}

> $failed_installs_file

if [ "$ENV" = "prod" ] ; then
    bash ./remove-prod-nodes.sh
else
    bash ./remove-dev-or-test-nodes.sh
fi

echo "======> creating kafka node..."
create_kafka_node

echo "======> initializing swarm manager..."
init_swarm_manager

echo "======> creating database node(s)..."
create_contacts_db_node &
#create_projects_db_node &

wait %1
create_contacts_db_result=$?

#wait %2
#create_projects_db_node=$?

#if [ $create_contacts_db_result -ne 0 ] || [ $create_projects_db_result -ne 0 ]
if [ $create_contacts_db_result -ne 0 ]
then
    echo "There was an error installing docker on the mysql or kafka nodes. The script will now exit."

    echo "=====> Cleaning up..."

    bash ./remove-all-nodes.sh

    exit 1
fi
echo "======> finished creating kafka and database nodes ..."

#contact_form_service_node hosts the email_notification and save_contact_to_db services
create_contact_form_service_node 1 &
#create_blog_ui_node 1 &

#bash ./create-node.sh createprojectservice 1 &
#bash ./create-node.sh listprojectsservice 1 &

wait

if [ "$BUILD_UI" = true ] ; then
    source set-contact-form-service-ip.sh

#    source set-list-projects-service-ip.sh

    bash /home/james/projects/jhinesconsulting/jhinesconsulting-blog-ui/scripts/build.sh

    cd /home/james/projects/jhinesconsulting/jhinesconsulting-blog-infrastructure/scripts
fi

bash ./remove-nodes-with-failed-docker-installations.sh

set_manager_node_env_variables

docker-machine ls
