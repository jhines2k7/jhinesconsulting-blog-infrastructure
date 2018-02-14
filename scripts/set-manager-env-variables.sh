#!/bin/bash

echo "=======> setting env variables for manager node"

{
    echo "DOCKER_HUB_USER=$1"
    echo "DOCKER_HUB_PASSWORD=$2"
    echo "JHC_DB_USER=$3"
    echo "JHC_DB_PASS=$4"
    echo "JHC_DB_ROOT_PASS=$5"
    echo "CONTACT_REQUEST_OUTPUT_CHANNEL=$6"
    echo "KAFKA_HOST=$7"
    echo "ZOOKEEPER_HOST=$8"
    echo "DB_HOST=$9"
} | sudo tee -a /etc/environment > /dev/null
