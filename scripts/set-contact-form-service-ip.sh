#!/usr/bin/env bash

function get_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'mockcontactformsubmissionservice')
}

machine=$(get_manager_machine_name)

export CONTACT_FORM_SUBMISSION_SERVICE_IP=$(docker-machine ip $machine):3000

echo "Contact form submission service ip: "
echo $CONTACT_FORM_SUBMISSION_SERVICE_IP

