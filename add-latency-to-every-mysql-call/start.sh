#!/bin/sh

# Start Toxiproxy in the background
/toxiproxy &

# Wait for 2 seconds to let Toxiproxy start
sleep 2

# Create proxy for every PROXY_ env variable
for values in $(env | grep '^PROXY_' | cut -d= -f2); do
  OLD_IFS="$IFS"
  IFS=':'
  set -- $values
  IFS="$OLD_IFS"

  NAME=$1
  LISTEN_PORT=$2
  UPSTREAM_PORT=$3
  LATENCY=$4
  
  /toxiproxy-cli -h 127.0.0.1:8474 create -l 0.0.0.0:$LISTEN_PORT -u $NAME:$UPSTREAM_PORT "$NAME"_proxy
  /toxiproxy-cli -h 127.0.0.1:8474 toxic add -t latency -a latency=$LATENCY "$NAME"_proxy
done

# Keep the container running
tail -f /dev/null