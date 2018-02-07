#!/usr/bin/env bash

function merge_compose_files {
    local blog_ui_compose_file="../services/blog/blog.yml"
    local kafka_service_compose_file="../services/backing-services/kafka-service.yml"
    local mysql_service_compose_file="../services/backing-services/mysql-service.yml"
    local log_sink_service_compose_file="../services/backing-services/log-sink-service/log-sink-service.yml"
    local http_source_task_compose_file="../services/contact-form-submission-service/http-source-task/http-source-task.yml"
    local db_sink_task_compose_file="../services/contact-form-submission-service/db-sink-task/db-sink-task.yml"

    echo "======> running docker compose config to create a merged compose file"

    docker-compose \
    -f $db_sink_task_compose_file \
    -f $log_sink_service_compose_file \
    -f $http_source_task_compose_file \
    -f $mysql_service_compose_file \
    -f $kafka_service_compose_file config \
    > ../services/docker-stack.yml

    echo "======> contents of the merged compose file"
    cat ../services/docker-stack.yml
}

manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'manager')

function copy_compose_file {
    echo "======> copying compose file to manager node ..."
    docker-machine scp ../services/docker-stack.yml $manager_machine:/home/ubuntu/
}

function build_and_push_services {
    echo "======> LOGGING_INPUT_DESTINATION: $LOGGING_INPUT_DESTINATION"
    echo "======> Running build and push commands for spring cloud stream app starters"
    bash ../services/backing-services/log-sink-service/build-and-push.sh &
    bash ../services/contact-form-submission-service/db-sink-task/build-and-push.sh &
    bash ../services/contact-form-submission-service/http-source-task/build-and-push.sh &

    wait
}

build_and_push_services

merge_compose_files

copy_compose_file

docker-machine ssh $manager_machine sudo docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD

docker-machine ssh $manager_machine \
    sudo docker stack deploy \
    --compose-file /home/ubuntu/docker-stack.yml \
    --with-registry-auth \
    blog

#remove merged compose file
rm ../services/docker-stack.yml