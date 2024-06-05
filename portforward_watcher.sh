#!/bin/bash

transmission_url="http://${TRHOST:=localhost}:${TRPORT:=9091}/transmission"

update_port_forward() {
  echo "port.dat has been updated."
  for i in {1..10}; do
    PORT=$(cat "/portforward/${PORTFILENAME:=port.dat}" | sed 's/[[:space:]]//g')

    echo "Update port forward to: ${PORT} for ${transmission_url}"
    transmission-remote ${transmission_url} -n ${TRUSER}:${TRPASSWORD} -p ${PORT}

    if [ $? -eq 0 ]; then
      echo "Transmission-remote command was successful."
      echo "OK" > /result.txt
      break
    else
      echo "Transmission-remote command failed. Retrying in 5 seconds..."
      echo "FAIL" > /result.txt
      sleep 5
    fi
  done
}

## Actual script starts here

# Update port on first run
sleep 5 # give transmission time to start
echo "Starting up..."
update_port_forward

# Watch for changes to port.dat
inotifywait -q -m -e close_write /portforward/port.dat |
  while read -r filename event; do
    update_port_forward
  done
