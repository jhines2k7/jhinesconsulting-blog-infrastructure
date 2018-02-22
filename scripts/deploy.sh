#!/usr/bin/env bash

function merge_compose_files {
    local blog_ui_compose_file="../services/blog/blog-ui.yml"
    local kafka_service_compose_file="../services/backing-services/kafka-service.yml"
    local contacts_db_compose_file="../services/backing-services/contacts-db.yml"
    local projects_db_compose_file="../services/backing-services/projects-db.yml"
    local log_sink_service_compose_file="../services/backing-services/log-sink-service/log-sink-service.yml"
    local contact_request_task_compose_file="../services/contact-service/contact-request-handler-task.yml"
    local save_contact_to_db_task_compose_file="../services/contact-service/save-contact-to-db-task.yml"
    local email_notification_task_compose_file="../services/contact-service/email-notification-task.yml"
    local create_project_request_handler_task_compose_file="../services/create-project-service/create-project-task.yml"
    local list_projects_service_handler_task_compose_file="../services/list-projects-service/list-projects-task.yml"
    local save_project_to_db_task_compose_file="../services/create-project-service/save-project-to-db-task/save-project-to-db-task.yml"

    if [ "$ENV" = "dev" ] ; then
        kafka_service_compose_file="../services/backing-services/kafka-service.dev.yml"
    fi

    echo "======> KAFKA_HOST: $KAFKA_HOST"
    echo "======> ZOOKEEPER_HOST: $ZOOKEEPER_HOST"
    echo "======> CONTACTS_DB_HOST: $CONTACTS_DB_HOST"
    echo "======> PROJECTS_DB_HOST: $PROJECTS_DB_HOST"

    echo "======> running docker compose config to create a merged compose file"

#    -f $email_notification_task_compose_file \
#    -f $blog_ui_compose_file \
#    -f $save_contact_to_db_task_compose_file \
#    -f $contact_request_task_compose_file \
#    -f $log_sink_service_compose_file \
    docker-compose \
    -f $save_project_to_db_task_compose_file \
    -f $create_project_request_handler_task_compose_file \
    -f $list_projects_service_handler_task_compose_file \
    -f $contacts_db_compose_file \
    -f $projects_db_compose_file \
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
    echo "======> LOGGING_INPUT_CHANNEL: $LOGGING_INPUT_CHANNEL"
    echo "======> Running build and push commands for spring cloud stream app starters"
    bash ../services/backing-services/log-sink-service/build-and-push.sh
    bash ../services/create-project-service/save-project-to-db-task/build-and-push.sh &
#    bash ../services/contact-form-submission-service/http-source-task/build-and-push.sh &
#    wait
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