#!/usr/bin/env bash

function get_contact_form_submission_service_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'formhandler')
}

machine=$(get_contact_form_submission_service_machine_name)

export CONTACT_FORM_SUBMISSION_SERVICE_IP=$(docker-machine ip $machine):3000