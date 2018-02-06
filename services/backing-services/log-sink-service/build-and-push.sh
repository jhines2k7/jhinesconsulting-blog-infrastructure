#!/usr/bin/env bash
wget http://repo.spring.io/libs-release/org/springframework/cloud/stream/app/log-sink-kafka-10/1.3.1.RELEASE/log-sink-kafka-10-1.3.1.RELEASE.jar

docker build -t jhines2017/log-sink-service:10-1.3.1.RELEASE . \
&& docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD \
&& docker push jhines2017/log-sink-service:10-1.3.1.RELEASE