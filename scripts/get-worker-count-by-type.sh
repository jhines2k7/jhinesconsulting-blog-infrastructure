#!/usr/bin/env bash

docker-machine ls --format "{{.Name}}" | grep $1 | wc -l
