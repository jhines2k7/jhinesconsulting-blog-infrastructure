#!/usr/bin/env bash
# download the jar file and save to this directory
wget http://repo.spring.io/libs-release/org/springframework/cloud/stream/app/http-source-kafka-10/1.3.1.RELEASE/http-source-kafka-10-1.3.1.RELEASE.jar

docker build -t jhines2017/http-source-worker:10-1.3.1.RELEASE . \
&& docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD \
&& docker push jhines2017/http-source-worker:10-1.3.1.RELEASE