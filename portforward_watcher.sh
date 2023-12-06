#!/bin/bash

# Update port on first run
sleep 10 # give transmission time to start
PORT=$(cat /portforward/port.dat | sed 's/[[:space:]]//g')
transmission_host=${TRHOST:="localhost"}
transmission_port=${TRPORT:="9091"}
transmission_url="http://${TRHOST}:${TRPORT}/transmission"
echo "Update port forward to: ${PORT} for ${transmission_url}"
transmission-remote ${transmission_url} -n ${TRUSER}:${TRPASSWD} -p ${PORT}

inotifywait -q -m -e close_write /portforward/port.dat |
while read -r filename event; do
  PORT=`cat /portforward/port.dat`
  echo "port.dat has been updated."
  echo "Update port forward to: ${PORT} for ${transmission_url}"
  transmission-remote ${transmission_url} -n ${TRUSER}:${TRPASSWD} -p ${PORT}
done
