#!/bin/bash

echo "=======> setting env variables for manager node"

{
    echo "DOCKER_HUB_USER=$1"
    echo "DOCKER_HUB_PASSWORD=$2"
    echo "JHC_DB_USER=$3"
    echo "JHC_DB_PASS=$4"
    echo "JHC_DB_ROOT_PASS=$5"
    echo "LOGGING_INPUT_CHANNEL=$6"
    echo "KAFKA_HOST=$7"
    echo "ZOOKEEPER_HOST=$8"
    echo "CONTACTS_DB_HOST=$9"
    echo "JHC_GMAIL_PASSWORD=${10}"
    echo "JHC_GMAIL_ADDRESS=${11}"
    echo "PROJECTS_DB_HOST=${12}"
    echo "PROJECTS_DB_PORT=${13}"
    echo "PROJECTS_DB_NAME=${14}"
    echo "CONTACTS_DB_PORT=${15}"
    echo "CONTACTS_DB_NAME=${16}"
    echo "KEYSTORE_PASSWORD=${17}"
} | sudo tee -a /etc/environment > /dev/null
