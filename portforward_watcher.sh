#!/bin/bash

# Update port on first run
sleep 10 # give transmission time to start
PORT=$(cat /portforward/port.dat | sed 's/[[:space:]]//g')
transmission_host=${TRHOST:="localhost"}
transmission_port=${TRPORT:="9091"}
transmission_url="http://${transmission_host}:${transmission_port}/transmission"
echo "Update port forward to: ${PORT} for ${transmission_url}"
transmission-remote "${transmission_url}" -n "${TRUSER}:${TRPASSWORD}" -p "${PORT}"
echo "result: $?"

inotifywait -q -m -e close_write /portforward/port.dat |
  while read -r; do
    PORT=$(cat /portforward/port.dat)
    echo "port.dat has been updated."
    echo "Update port forward to: ${PORT} for ${transmission_url}"
    transmission-remote "${transmission_url}" -n "${TRUSER}:${TRPASSWORD}" -p "${PORT}"
    echo "result: $?"
  done
