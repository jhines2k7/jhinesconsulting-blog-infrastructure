#!/usr/bin/env bash

# changing context
cd ../services/contact-form-submission-service/http-source-task

# download the jar file and save to this directory
FILE=http-source-kafka-10-1.3.1.RELEASE.jar
echo "=======> Checking for http source jar file..."
if [ -f $FILE ]; then
   echo "=======> ...http source jar file has already been downloaded"
else
    echo "=======> ...http source jar file has not been downloaded"
    echo "======> Downloading jar file for http source service"
    wget http://repo.spring.io/libs-release/org/springframework/cloud/stream/app/http-source-kafka-10/1.3.1.RELEASE/http-source-kafka-10-1.3.1.RELEASE.jar
fi

docker build -t jhines2017/http-source-worker:10-1.3.1.RELEASE . \
&& docker login --username=$DOCKER_HUB_USER --password=$DOCKER_HUB_PASSWORD \
&& docker push jhines2017/http-source-worker:10-1.3.1.RELEASE