#!/usr/bin/env bash

kafka_host="kafka"
zookeeper_host="zookeeper"
mysql_host="mysql"

if [ "$ENV" = "dev" ]
then
    kafka_machine_ip=$(get_ip $(docker-machine ls --format "{{.Name}}" | grep 'kafka'))
    mysql_host=$(get_ip $(docker-machine ls --format "{{.Name}}" | grep 'mysql-jhc'))

    kafka_host=$kafka_machine_ip
    zookeeper_host=$kafka_machine_ip
fi

export KAFKA_HOST=$kafka_machine_ip
export ZOOKEEPER_HOST=$kafka_machine_ip
export DB_HOST=$mysql_host

./runremote.sh \
./set-manager-env-variables.sh \
$(get_manager_machine_name)  \
"$DOCKER_HUB_USER" \
"$DOCKER_HUB_PASSWORD" \
"$JHC_DB_USER" \
"$JHC_DB_PASS" \
"$JHC_DB_ROOT_PASS" \
"$LOGGING_INPUT_CHANNEL" \
"$kafka_host" \
"$zookeeper_host" \
"$mysql_host"