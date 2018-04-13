#!/usr/bin/env bash

function get_contact_form_service_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'jhccontactformservice')
}

machine=$(get_contact_form_service_machine_name)

export CONTACT_FORM_SERVICE_IP=$(docker-machine ip $machine):3000