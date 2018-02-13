#!/usr/bin/env bash

# changing context
cd ../services/contact-form-submission-service/http-source-task

# download the jar file and save to this directory
FILE=http-source-kafka-10-1.3.2.BUILD-SNAPSHOT.jar
echo "=======> Checking for http source jar file..."
if [ -f $FILE ]; then
   echo "=======> ...http source jar file has already been downloaded"
else
    echo "=======> ...http source jar file has not been downloaded"
    echo "======> Downloading jar file for http source service"
    wget https://s3.us-east-2.amazonaws.com/jhinesconsulting/http-source-kafka-10-1.3.2.BUILD-SNAPSHOT.jar

    docker build -t jhines2017/http-source-worker:10-1.3.2.BUILD-SNAPSHOT . \
    && docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD \
    && docker push jhines2017/http-source-worker:10-1.3.2.BUILD-SNAPSHOT
fi