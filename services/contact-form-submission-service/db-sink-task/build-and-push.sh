#!/usr/bin/env bash

# changing context
cd ../services/contact-form-submission-service/db-sink-task

#check if jar file has already been downloaded
FILE=jdbc-sink-kafka-10-1.3.1.RELEASE-sources.jar

echo "=======> Checking for log sink jar file..."
if [ -f $FILE ]; then
   echo "=======> ...log sink jar file has already been downloaded"
else
    echo "=======> ...log sink jar file has not been downloaded"
    echo "======> Downloading jar file for log sink service"
    wget http://repo.spring.io/libs-release/org/springframework/cloud/stream/app/jdbc-sink-kafka-10/1.3.1.RELEASE/jdbc-sink-kafka-10-1.3.1.RELEASE-sources.jar
fi

docker build -t jhines2017/db-sink-worker:10-1.3.1.RELEASE . \
&& docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD \
&& docker push jhines2017/db-sink-worker:10-1.3.1.RELEASE