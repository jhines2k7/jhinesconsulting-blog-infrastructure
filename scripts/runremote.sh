#!/bin/bash
# runremote.sh (revised, not dependent upon /dev/stdin)
# usage: runremote.sh localscript remoteuser remotehost arg1 arg2 ...

realscript=$1
host=$2
shift 2

# escape the arguments
declare -a args

count=0
for arg in "$@"; do
  args[count]=$(printf '%q' "$arg")
  count=$((count+1))
done

{
  printf '%s\n' "set -- ${args[*]}"
  cat "$realscript"
} | docker-machine ssh $host "bash -s"