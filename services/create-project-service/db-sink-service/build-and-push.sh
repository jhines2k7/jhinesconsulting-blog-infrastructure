#!/usr/bin/env bash

# changing context
cd ../services/backing-services/log-sink-service

#check if jar file has already been downloaded
FILE=log-sink-kafka-10-1.3.1.RELEASE.jar

echo "=======> Checking for log sink jar file..."
if [ -f $FILE ]; then
   echo "=======> ...log sink jar file has already been downloaded"
else
    echo "=======> ...log sink jar file has not been downloaded"
    echo "======> Downloading jar file for log sink service"
    wget http://repo.spring.io/libs-release/org/springframework/cloud/stream/app/log-sink-kafka-10/1.3.1.RELEASE/log-sink-kafka-10-1.3.1.RELEASE.jar

    docker build -t jhines2017/log-sink-service:10-1.3.1.RELEASE . \
    && docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD \
    && docker push jhines2017/log-sink-service:10-1.3.1.RELEASE
fi