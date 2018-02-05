#!/bin/bash

echo "=======> setting env variables for manager node"

{
    echo "KAFKA_HOST=$1"
    echo "ZOOKEEPER_HOST=$2"
    echo "DOCKER_HUB_USER=$3"
    echo "DOCKER_HUB_PASSWORD=$4"
} | sudo tee -a /etc/environment > /dev/null
