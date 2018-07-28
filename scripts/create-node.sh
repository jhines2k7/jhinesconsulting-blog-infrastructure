#!/bin/bash

failed_installs_file="./failed_installs.txt"
node_type=$1
num_workers=$2

function get_ip {
    echo $(docker-machine ip $1)
}

function get_manager_machine_name {
    echo $(docker-machine ls --format "{{.Name}}" | grep 'jhcmanager')
}

function get_worker_token {
    local manager_machine=$(get_manager_machine_name)
    # gets swarm manager token for a worker node
    echo $(docker-machine ssh $manager_machine sudo docker swarm join-token worker -q)
}

function join_swarm {
    local manager_machine=$(get_manager_machine_name)
    
    docker-machine ssh $1 \
    sudo docker swarm join \
        --token $(get_worker_token) \
        $(get_ip $manager_machine):2377
}

function copy_sql_schema {
    echo "======> copying sql schema file to mysql node ..."

    local db_machine=$(docker-machine ls --format "{{.Name}}" | grep 'jhccontactsdb')

    local sql_directory=/schemas

    if [ "$PROVIDER" = "aws" ]
    then
        sql_directory=/home/ubuntu/schemas
    fi

    docker-machine ssh $db_machine mkdir $sql_directory

    if [ $? -ne 0 ]
    then
        exit 1
    fi

    docker-machine scp ../docker/db/contacts.sql $db_machine:$sql_directory
}

function create_node {
    local node_type=$1
    local ID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
    local instance_type="t2.micro"
    local vpc_id="vpc-3670d45e"
    local security_group="jhines-consulting-blog"
    local machine_id=$node_type-$ID
    local subnet_id="subnet-3f2d8f57"
    local ami="ami-6a5f6a0f"
#    local ami="ami-4f80b52a"
    local aws_region="us-east-2"
    local size="1gb"

    echo "======> creating $machine_id"

    # t2.nano=0.5
    # t2.micro=1
    # t2.small=2

    case "$node_type" in
    jhckafka)
        instance_type="t2.small"
        size="2gb"
        ;;
    jhcui) instance_type="t2.nano"
        size="512mb"
        ;;
    ui-qa) instance_type="t2.nano"
        size="512mb"
        ;;
    esac

    if [ "$ENV" = "dev" ] ||  [ "$ENV" = "test" ]
    then
        security_group="jhines-consulting-blog-test"
    fi

    if [ "$PROVIDER" = "aws" ] ; then
        echo "======> launching $instance_type AWS instance..."

        docker-machine create \
        --engine-label "node.type=$node_type" \
        --driver amazonec2 \
        --amazonec2-ami $ami \
        --amazonec2-vpc-id $vpc_id \
        --amazonec2-subnet-id $subnet_id \
        --amazonec2-security-group $security_group \
        --amazonec2-instance-type $instance_type \
        --amazonec2-region $aws_region \
        --amazonec2-zone a \
        $machine_id
    else
        echo "======> launching $size Digital Ocean instance..."

        docker-machine create \
        --engine-label "node.type=$node_type" \
        --driver digitalocean \
        --digitalocean-image ubuntu-18-04-1-x64 \
        --digitalocean-size $size \
        --digitalocean-access-token $DIGITALOCEAN_ACCESS_TOKEN \
        $machine_id
    fi

    if [ ! -e "$failed_installs_file" ] ; then
        touch "$failed_installs_file"
    fi
    
    #check to make sure docker was properly installed on node
    echo "======> making sure docker is installed on $machine_id"
    docker-machine ssh $machine_id docker

    if [ $? -ne 0 ]
    then
        if [ $node_type = "jhcmanager" ] || [ $node_type = "jhccontactsdb" ] || [ $node_type = "jhckafka" ]
        then
            exit 2
        else
            echo "$machine_id" >> $failed_installs_file
        fi

        return 1
    fi

    if [ "$node_type" = "jhccontactsdb" ]
    then
        copy_sql_schema contacts

        if [ $? -ne 0 ]
        then
            exit 2
        fi
    fi

    bash ./set-ufw-rules.sh $machine_id
    
    if [ "$node_type" != "jhcmanager" ]
    then
        join_swarm $machine_id
    fi
}

index=0

if [ $num_workers -gt 1 ]
then
    echo "======> Creating $num_workers nodes"

    for i in $(eval echo "{1..$num_workers}")      
        do
            create_node $node_type &

            ((index++))                
    done

    wait
    echo "======> Finished creating $num_workers nodes. Check $failed_installs_file for any nodes that may not have been created properly"
else
    echo "======> Creating $num_workers node"
    create_node $node_type
fi
