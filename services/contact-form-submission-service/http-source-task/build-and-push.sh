#!/usr/bin/env bash
docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD \
&& docker push ideafoundry/save-occasion-order-to-mysql-worker:$VERSION-SNAPSHOT