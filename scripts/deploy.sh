#!/usr/bin/env bash

function merge_compose_files {
    local blog_ui_compose_file="../services/blog/blog-ui.yml"

    local backing_services__kafka_service_compose_file="../services/backing-services/kafka-service.yml"
    local backing_services__contacts_db_compose_file="../services/backing-services/contacts-db.digitalocean.yml"

    if [ "$PROVIDER" = "aws" ] ; then
       backing_services__contacts_db_compose_file="../services/backing-services/contacts-db.aws.yml"
    fi

    local backing_services__projects_db_compose_file="../services/backing-services/projects-db.yml"
    local backing_services__log_sink_service_compose_file="../services/backing-services/log-sink-service/log-sink-service.yml"

    local contact_form_service__contact_form_task_compose_file="../services/contact-form-service/contact-form-task.yml"
    local contact_form_service__save_contact_to_db_task_compose_file="../services/contact-form-service/save-contact-to-db-task.yml"
    local contact_form_service__email_notification_task_compose_file="../services/contact-form-service/email-notification-task.yml"

    local create_project_service__create_project_task_compose_file="../services/create-project-service/create-project-task.yml"
    local create_project_service__save_project_to_db_task_compose_file="../services/create-project-service/save-project-to-db-task.yml"

    local list_projects_service__list_projects_task_compose_file="../services/list-projects-service/list-projects-task.yml"

    if [ "$ENV" = "dev" ] ; then
        backing_services__kafka_service_compose_file="../services/backing-services/kafka-service.dev.yml"
    fi

    echo "======> KAFKA_HOST: $KAFKA_HOST"
    echo "======> ZOOKEEPER_HOST: $ZOOKEEPER_HOST"
    echo "======> CONTACTS_DB_HOST: $CONTACTS_DB_HOST"
    echo "======> PROJECTS_DB_HOST: $PROJECTS_DB_HOST"

    echo "======> running docker compose config to create a merged compose file"

#    -f $create_project_service__save_project_to_db_task_compose_file \
#    -f $create_project_service__create_project_task_compose_file \
#    -f $list_projects_service__list_projects_task_compose_file \
#    -f $backing_services__projects_db_compose_file \
#    -f $backing_services__log_sink_service_compose_file \
    docker-compose \
    -f $blog_ui_compose_file \
    -f $contact_form_service__email_notification_task_compose_file \
    -f $contact_form_service__save_contact_to_db_task_compose_file \
    -f $contact_form_service__contact_form_task_compose_file \
    -f $backing_services__contacts_db_compose_file \
    -f $backing_services__kafka_service_compose_file config \
    > ../services/docker-stack.yml

    echo "======> contents of the merged compose file"

    cat ../services/docker-stack.yml
}

manager_machine=$(docker-machine ls --format "{{.Name}}" | grep 'manager')

function copy_compose_file {
    directory=/

    if [ "$PROVIDER" = "aws" ] ; then
        directory=/home/ubuntu/
    fi

    echo "======> copying compose file to manager node ..."
    docker-machine scp ../services/docker-stack.yml $manager_machine:$directory
}

function build_and_push_services {
    echo "======> LOGGING_INPUT_CHANNEL: $LOGGING_INPUT_CHANNEL"
    echo "======> Running build and push commands for spring cloud stream app starters"
    bash ../services/backing-services/log-sink-service/build-and-push.sh
}

#build_and_push_services

merge_compose_files

copy_compose_file

docker-machine ssh $manager_machine sudo docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD

directory=/

if [ "$PROVIDER" = "aws" ] ; then
    directory=/home/ubuntu/
fi

docker-machine ssh $manager_machine \
    sudo docker stack deploy \
    --compose-file $directory/docker-stack.yml \
    --with-registry-auth \
    blog

#remove merged compose file
rm ../services/docker-stack.yml