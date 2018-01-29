#!/bin/bash

{
    echo "NUM_NODES=$1"
    echo "NODE_INDEX=$2"
} | sudo tee -a /etc/environment > /dev/null
