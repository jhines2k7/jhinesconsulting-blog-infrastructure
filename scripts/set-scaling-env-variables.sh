machine=$1
num_nodes=$2
idx=$3

docker-machine ssh $machine 'bash -s' < ./set-scaling-variables.sh $num_nodes $idx
