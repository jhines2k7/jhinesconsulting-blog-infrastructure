#!/usr/bin/env bash

export VERSION=1.0.0

docker build -t jhines2017/mock-form-submission-service:$VERSION . \
&& docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD \
&& docker push jhines2017/mock-form-submission-service:$VERSION