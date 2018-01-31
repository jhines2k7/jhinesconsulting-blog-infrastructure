#!/usr/bin/env bash

export VERSION=2.7.4

docker build -t ideafoundry/mock-occasion-api:$VERSION . \
&& docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD \
&& docker push ideafoundry/mock-occasion-api:$VERSION