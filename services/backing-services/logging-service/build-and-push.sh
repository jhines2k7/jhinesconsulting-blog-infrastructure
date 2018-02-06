#!/usr/bin/env bash
docker build -t jhines2017/http-source-worker:10-1.3.1.RELEASE . \
&& docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD \
&& docker push jhines2017/http-source-worker:10-1.3.1.RELEASE