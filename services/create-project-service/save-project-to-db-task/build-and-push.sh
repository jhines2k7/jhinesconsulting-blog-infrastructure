#!/usr/bin/env bash

# changing context
cd ../services/create-project-service/save-project-to-db-task

#check if jar file has already been downloaded
FILE=jdbc-sink-kafka-10-1.3.1.RELEASE.jar

echo "=======> Checking for jdbc sink jar file..."
if [ -f $FILE ]; then
   echo "=======> ...jdbc sink jar file has already been downloaded"
else
    echo "=======> ...jdbc sink jar file has not been downloaded"
    echo "======> Downloading jar file for jdbc sink service"
    wget http://repo.spring.io/libs-release/org/springframework/cloud/stream/app/jdbc-sink-kafka-10/1.3.1.RELEASE/jdbc-sink-kafka-10-1.3.1.RELEASE.jar

    docker build -t jhines2017/save-project-to-db-worker:10-1.3.1.RELEASE . \
    && docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD \
    && docker push jhines2017/save-project-to-db-worker:10-1.3.1.RELEASE
fi