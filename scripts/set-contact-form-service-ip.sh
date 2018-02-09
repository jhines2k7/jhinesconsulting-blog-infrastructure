#!/usr/bin/env bash

function get_contact_request_handler_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'contactrequesthandler')
}

machine=$(get_contact_request_handler_machine_name)

export CONTACT_FORM_SUBMISSION_SERVICE_IP=$(docker-machine ip $machine):3000