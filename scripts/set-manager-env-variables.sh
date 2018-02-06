#!/bin/bash

echo "=======> setting env variables for manager node"

{
    echo "DOCKER_HUB_USER=$1"
    echo "DOCKER_HUB_PASSWORD=$2"
} | sudo tee -a /etc/environment > /dev/null
